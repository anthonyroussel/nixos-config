{
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint ];
  };

  hardware.printers.ensurePrinters = [
    {
      name = "home_Epson-ET-2756";
      description = "EPSON ET-2756";
      deviceUri = "ipp://192.168.1.20";
      model = "gutenprint.5.3://escp2-et2750/expert";
      location = "Home";
      ppdOptions = {
        PageSize = "A4";
      };
    }
  ];
}
