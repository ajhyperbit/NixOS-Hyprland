{...}: {
  # BOOT related stuff
  boot = {
    kernelPackages = pkgs.linuxPackages_6_6; # LTS Kernel 6.6

    kernelParams = [
      "systemd.mask=systemd-vconsole-setup.service"
      "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
      "nowatchdog"
      #"modprobe.blacklist=sp5100_tco" #watchdog for AMD
      #"modprobe.blacklist=iTCO_wdt" #watchdog for Intel
      "nohibernate"
    ];
    tmp.cleanOnBoot = true;
    #supportedFilesystems = ["ntfs"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    plymouth.enable = false;
  };
}
