# Webcam Daemon setup via ustreamer. Assumes Raspberry Pi environment
final: prev: {
  ustreamer = (
    prev.ustreamer.override {
      withSystemd = false;
      withJanus = false;
    }
  );
}
