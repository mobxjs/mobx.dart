void busy() {
  int a = 0;
  for (int i = 0; i < 1_00; i++) {
    a++;
  }
  a;
}

enum KairoState { success, fail }
