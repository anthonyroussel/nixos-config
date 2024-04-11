{
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.machine1.shell") {
          if (subject.isInGroup("wheel")) {
            return polkit.Result.YES;
          }
        }
      });
    '';
  };
}
