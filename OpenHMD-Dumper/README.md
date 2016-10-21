# OpenHMD-Dumper
A tool for trying to get packets dumping from a HMD device and convert them to a readable output for decyphering.

## Example Output
This tool will let you open a HID device and will try to dump the sensor data payload as a hexidecimal dump.
This can then be used to decode what the packet contains using i.e gnuplot.

    secret@OpenHMD:~/Code/OpenHMD-Tools/OpenHMD-Dumper$ ./examples/dumper/simple 
    1 - Found path (Device::Bus) 0002:0008:00 - Device Logitech, USB Receiver
    2 - Found path (Device::Bus) 0002:0008:01 - Device Logitech, USB Receiver
    3 - Found path (Device::Bus) 0002:0006:00 - Device DeePoon VR, Inc., DeePoon Tracker Device
    Enter the device you want OpenHMD to try opening: 3
    device 0
      vendor:  DeePoon VR, Inc.
      product: DeePoon Tracker Device
      path:    0002:0006:00

    0B:00:00:01:9A:56:B0:0C:A4:CF:B9:99:FF:50:77:F0:E2:FD:14:AC:FF:FF:78:00:00:FF:FF:F8:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:9B:56:B5:0C:89:D3:B9:99:FF:55:B7:F0:D7:3D:13:BE:FF:FF:78:00:00:80:00:0C:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:9C:56:B6:0C:75:D7:B9:99:FF:5A:FF:F0:BB:3D:14:DE:00:00:7F:FF:F8:FF:FF:F8:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:9D:56:B5:0C:5A:DB:B9:99:FF:5F:17:F0:4B:7D:15:A6:00:00:77:FF:FE:3F:FF:F8:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:9E:56:B4:0C:3F:DF:B9:99:FF:5B:FF:F0:67:FD:14:E4:00:00:28:00:00:C0:00:0E:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:9F:56:B8:0C:2A:E3:B9:99:FF:56:27:F1:3C:BD:14:16:00:00:1F:FF:FE:00:00:22:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:A0:56:B8:0C:16:E7:B9:99:FF:5E:77:F1:31:3D:11:DA:00:00:7F:FF:FB:80:00:24:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:A1:56:B5:0C:FC:EA:B9:99:FF:5D:E7:F0:E9:FD:12:6E:00:00:7F:FF:F8:BF:FF:E2:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:A2:56:B4:0C:E1:EE:B9:99:FF:4F:A7:F0:F4:7D:14:DA:FF:FF:CF:FF:FE:3F:FF:E2:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:A3:56:B1:0C:CD:F2:B9:99:FF:54:F7:F0:D6:FD:13:30:FF:FF:D0:00:00:FF:FF:F8:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:9E:07:AA:EC:52:EA:00:00:00:00:00:00:00:00:00:00:00:00:00:00
    0B:00:00:01:A4:56:B2:0C:B2:F6:B9:99:FF:5F:37:F1:25:FD:12:C8:FF:FF:C8:00:03:40:00:0E:FF:57:07:F1:14:3D:16:26:00:00:27:FF:FB:7F:FF:E4:CB:07:D7:EC:53:E9:00:00:00:00:00:00:00:00:00:00:00:00:00:00

## Compiling
We currently suggest building with autotools using the same process as the normal OpenHMD driver.
_DON'T install this driver_, as it will overwrite any normal installed OpenHMD driver, this is ment to run from the compiled folder.

Using make:

    ./autogen.sh
    ./configure
    make

## Running:

    ./samples/dumper/simple
