#!/bin/bash

# Function to collect system information using dmidecode
collect_system_info() {
  echo "Collecting BIOS Information..."
  bios_info=$(sudo dmidecode --type bios)
  
  echo "Collecting System Information..."
  system_info=$(sudo dmidecode --type system)
  
  echo "Collecting Baseboard Information..."
  baseboard_info=$(sudo dmidecode --type baseboard)
  
  echo "Collecting Chassis Information..."
  chassis_info=$(sudo dmidecode --type chassis)
}

# Function to insert collected information into XML
insert_into_xml() {
  sysinfo_data="
  <sysinfo type='smbios'>
      <bios>
        $(echo "$bios_info" | awk '/Vendor/ {print "<entry name=\"vendor\">" $2 "</entry>"}' | sed 's/.$//')
        $(echo "$bios_info" | awk '/Version/ {print "<entry name=\"version\">" $2 "</entry>"}' | sed 's/.$//')
        $(echo "$bios_info" | awk '/Release Date/ {print "<entry name=\"date\">" $4 "</entry>"}' | sed 's/.$//')
        $(echo "$bios_info" | awk '/BIOS Revision/ {print "<entry name=\"release\">" $3 "</entry>"}' | sed 's/.$//')
      </bios>
      <system>
        $(echo "$system_info" | awk '/Manufacturer/ {print "<entry name=\"manufacturer\">" $2 "</entry>"}' | sed 's/.$//')
        $(echo "$system_info" | awk '/Product Name/ {print "<entry name=\"product\">" $4 "</entry>"}' | sed 's/.$//')
        $(echo "$system_info" | awk '/Version/ {print "<entry name=\"version\">" $3 "</entry>"}' | sed 's/.$//')
        $(echo "$system_info" | awk '/Serial Number/ {print "<entry name=\"serial\">" $3 "</entry>"}' | sed 's/.$//')
        $(echo "$system_info" | awk '/UUID/ {print "<entry name=\"uuid\">" $2 "</entry>"}' | sed 's/.$//')
      </system>
      <baseBoard>
        $(echo "$baseboard_info" | awk '/Manufacturer/ {print "<entry name=\"manufacturer\">" $2 "</entry>"}' | sed 's/.$//')
        $(echo "$baseboard_info" | awk '/Product Name/ {print "<entry name=\"product\">" $4 "</entry>"}' | sed 's/.$//')
        $(echo "$baseboard_info" | awk '/Version/ {print "<entry name=\"version\">" $3 "</entry>"}' | sed 's/.$//')
        $(echo "$baseboard_info" | awk '/Serial Number/ {print "<entry name=\"serial\">" $3 "</entry>"}' | sed 's/.$//')
      </baseBoard>
      <chassis>
        $(echo "$chassis_info" | awk '/Manufacturer/ {print "<entry name=\"manufacturer\">" $2 "</entry>"}' | sed 's/.$//')
        $(echo "$chassis_info" | awk '/Version/ {print "<entry name=\"version\">" $3 "</entry>"}' | sed 's/.$//')
        $(echo "$chassis_info" | awk '/Serial Number/ {print "<entry name=\"serial\">" $3 "</entry>"}' | sed 's/.$//')
        $(echo "$chassis_info" | awk '/Asset Tag/ {print "<entry name=\"asset\">" $3 "</entry>"}' | sed 's/.$//')
        $(echo "$chassis_info" | awk '/SKU Number/ {print "<entry name=\"sku\">" $3 "</entry>"}' | sed 's/.$//')
      </chassis>
  </sysinfo>
  "
  
  smbios_data="<smbios mode=\"sysinfo\"/>"

  # Prompt user for the XML file
  read -p "Enter the path to the XML file (e.g., /etc/libvirt/qemu/your_vm.xml): " xml_file

  # Insert the sysinfo XML data into the virtual machine XML file
  sed -i "/<vcpu.*<\/vcpu>/a ${sysinfo_data}" "$xml_file"

  # Insert the smbios XML data into the virtual machine XML file under OS
  sed -i "/<os firmware=\"efi\">/a \ \ \ \ ${smbios_data}" "$xml_file"

  echo "XML data inserted successfully. Please check your XML configuration."
}

# Execute the functions
collect_system_info
insert_into_xml
