import 'package:mobx/src/core/reaction.dart';

typedef ReactionDisposer = void Function();
ReactionDisposer autorun(Function() fn) {
  Reaction r;

  r = Reaction(() {
    r.track(fn);
  });

  r.schedule();

  return r.dispose;
}
