{...}: {
  networking.hostName = "sylveon";

  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.extraEntries = ''
    menuentry "UEFI Firmware settings" --class driver {
      fwsetup
    }

    menuentry "Shutdown" --class shutdown {
      halt
    }

    menuentry "Restart" --class restart {
      reboot
    }
  '';

  networking.extraHosts = ''
    10.0.0.46 obs.flatkat.me
    192.168.0.228 xpm.silicondt.com wol.silicondt.com log.silicondt.com
  '';
}
