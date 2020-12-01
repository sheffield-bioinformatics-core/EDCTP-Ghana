import os
import tempfile
import glob

import tabulate
import slack
from slack.errors import SlackApiError

def get_coverage(run_id: str):


    result = dict()
    summary=dict(
        total=0,
        hq=0,
        lq=0
    )
    # get all coverage files
    files = glob.glob("/analysis/"+run_id+"/*.gisaid.fasta.non_n_count")

    # for every file get the coverage
    for file in files:
        file_name = os.path.basename(file)
        barcode = file_name.split(".")[0]
        print(barcode)
        f = open(file, "rb")
        for i in f:
            count = int(i.rstrip())
            wuhan_count = 29870
            percent = count / wuhan_count
            print(percent)
            summary["total"]+=1
            if percent >= 0.95:
                summary["hq"]+=1
            if percent >= 0.5:
                summary["lq"]+=1

        result[barcode] = percent
        f.close()



    rows = [(sample, result[sample]) for sample in result]

    return (tabulate.tabulate(rows, headers=["Sample","Coverage"], tablefmt="presto"),summary)


def post_slack_message(text: str, title: str = None, channel: str = None, attachments: list = None, bot: str = None,
                       blocks: list = None, **kwargs):
    """
    Post a slack message to notify users that the run has complete and summarise the results.
    """

    title = title or ''


    token = os.environ.get('SLACK_TOKEN')

    client = slack.WebClient(token=token, timeout=60)

    channel = '#{}'.format(channel)

    if attachments:
        for attachment in attachments:
            print("attaching to slack message: " + attachment)
            # file_type = os.path.basename(attachment).split(".")[1]
            with open(attachment, "rb") as f:
                try:
                    response = client.files_upload(
                        channels=channel,
                        file=attachment,
                        title=os.path.basename(attachment),
                        initial_comment=text
                    )
                    print(response)
                except SlackApiError as e:
                    print(f"message: {e.message}, response: {e.response}")
                    raise e
            f.close()
    else:
        response = client.chat_postMessage(channel=channel, text="*" + title + "*\n" + text, blocks=blocks)

    return response.data

if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser(description='Send coverage report')
    parser.add_argument('--run-id',dest="run_id",type=str,help='the id of the sequencing run')

    args = parser.parse_args()

    coverage,summary = get_coverage(run_id=args.run_id)


    fd, path = tempfile.mkstemp()

    with os.fdopen(fd, 'w') as tmp:
        tmp.write(coverage)

    post_slack_message(
        text="""*PIPELINE COMPLETE*
""" + args.run_id + """
_""" + str(summary["total"]) + """ samples sequenced, """+ str(summary["hq"]) + """ above 0.95, """ + str(summary["lq"]) + """ above 0.5_""",
        title="PIPELINE COMPLETE "+ args.run_id,
        channel="edctp-ghana",
        attachments=[path]
    )