## grub2引导Linux系统

```shell
# 这个是我的 linux 分区，可以根据需要调整 set ro
set root=(hd0,gpt5) 
# 你的linux内核,可以通过 Tab 补全，告知 Grub 内核镜像在分区中的位置，以及根文件系统的位置
linux /boot/vmlinuz-4.17.1-24 root=/dev/sda5
# 同样可以用 tab 补全。设置虚拟文件系统 initial ramdisk 文件的位置
initrd /boot/initrd.img-4.17.1-24
```