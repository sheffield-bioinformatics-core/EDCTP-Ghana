# EDCTP-Ghana
EDCTP-Ghana SARS-CoV2-Sequencing Project


# EDCTP Nanopore Laptop Setup




## Install Conveyor LIMS System



## Configure Conveyor LIMS System


## Install MinKNOW 20.06.4

https://community.nanoporetech.com/protocols/experiment-companion-minknow/v/mke_1013_v1_revbf_11apr2016/installing-minknow-on-linu

## Configure MinKNOW For GPU Basecalling

https://community.nanoporetech.com/posts/enabling-gpu-basecalling-f

1. Identify guppy version:
```
/opt/ont/minknow/bin/guppy_basecall_server --version
```
2. Download GPU version
```
https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_<version>_linux64.tar.gz
```
3. Extract
```
tar -xvf ont-guppy_<version>_linux64.tar.gz
```
4. Update MinKNOW configuration 
```
sudo /opt/ont/minknow/bin/config_editor --conf application --filename /opt/ont/minknow/conf/app_conf \
    --set guppy.server_executable="/home/myuser/ont-guppy/bin/guppy_basecall_server" \
    --set guppy.client_executable="/home/myuser/ont-guppy/bin/guppy_basecaller" \
    --set guppy.gpu_calling=1 \
    --set guppy.num_threads=3 \
    --set guppy.ipc_threads=2
```
5. Stop MinKNOW service
```
sudo service minknow stop
```
6. Kill any guppy basecall servers running
```
ps -A | grep guppy_basecall_server
sudo killall guppy_basecall_server
```
7. Start the MinKNOW service
```
sudo service minknow start
```
8. Confirm `guppy_basecall_server` is running
```
nvidia-smi
```

```
Tue Sep  8 09:12:14 2020       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 440.100      Driver Version: 440.100      CUDA Version: 10.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 1650    Off  | 00000000:01:00.0 Off |                  N/A |
| N/A   56C    P0    12W /  N/A |   1300MiB /  3914MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0     11799      C   ...-guppy-3.2.10/bin/guppy_basecall_server  1289MiB |
+-----------------------------------------------------------------------------+

```




