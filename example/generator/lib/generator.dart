/// Support for doing something awesome.
///
/// More dartdocs go here.
library generator;

import 'package:build/build.dart';
import 'package:generator/src/subject.dart';
import 'generator.dart';

export 'src/generator_base.dart';


Builder testBuilder(BuilderOptions options) => TestBuilder();
Builder subjBuilder(BuilderOptions options) => TestSubjectImpl().subjectBuilder;
Builder descBuilder(BuilderOptions options) => TestSubjectImpl().descriptorBuilder;
Builder reactorBuilder(BuilderOptions options) => TestSubjectReactor();