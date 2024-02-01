# Updating Virtual Machine Configuration in Virt-Manager

## 1. Obtain System Information

### BIOS Information
```bash
sudo dmidecode --type bios
```

### System Information
```bash
sudo dmidecode --type system
```

### Baseboard Information
```bash
sudo dmidecode --type baseboard
```

### Chassis Information
```bash
sudo dmidecode --type chassis
```

## 2. Open Virtual Machine Manager

1. Launch Virtual Machine Manager on your Linux machine.

## 3. Enable XML Editing

2. Click on "Edit" in the menu bar.
3. Select "Preferences."
4. Check the box next to 'Enable XML editing.'

## 4. Edit Virtual Machine XML

5. Select the virtual machine you want to modify.
6. Click on "View" in the menu bar.
7. Select "Details."
8. Navigate to the "XML" tab.

## 5. Insert Updated XML Information

9. Insert the following XML block into the configuration, replacing the placeholders with your system information:

```xml
<sysinfo type='smbios'>
    <bios>
      <entry name='vendor'>YourVendor</entry>
      <entry name='version'>YourVersion</entry>
      <entry name='date'>YourDate</entry>
      <entry name='release'>YourRelease</entry>
    </bios>
    <system>
      <entry name='manufacturer'>YourManufacturer</entry>
      <entry name='product'>YourProduct</entry>
      <entry name='version'>YourSystemVersion</entry>
      <entry name='serial'>YourSystemSerial</entry>
      <entry name='uuid'>YourUUID</entry>
    </system>
    <baseBoard>
      <entry name='manufacturer'>YourBaseboardManufacturer</entry>
      <entry name='product'>YourBaseboardProduct</entry>
      <entry name='version'>YourBaseboardVersion</entry>
      <entry name='serial'>YourBaseboardSerial</entry>
    </baseBoard>
    <chassis>
      <entry name='manufacturer'>YourChassisManufacturer</entry>
      <entry name='version'>YourChassisVersion</entry>
      <entry name='serial'>YourChassisSerial</entry>
      <entry name='asset'>YourChassisAsset</entry>
      <entry name='sku'>YourChassisSKU</entry>
    </chassis>
    <os firmware="efi">
        <smbios mode="sysinfo"/>
    </os>
</sysinfo>
```

10. Save the changes.

## 6. Restart Virtual Machine

11. Close the XML view and return to the virtual machine details.
12. Restart the virtual machine by right-clicking on it and selecting "Start" or "Restart."
