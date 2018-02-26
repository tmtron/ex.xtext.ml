# Testproject for Xtext with multiple grammars

The repository contains multiple xtext projects:

* `.a`: grammar a which is independent
* `.b`: grammar b, which inherits from grammar a
* `.c`: grammar c, which inherits from grammar b

and simple demo-project that use the grammars and have each a very simple model file:
* `demo/demoA`: uses grammar `.a` (which is independent)
* `demo/demoB`: uses grammar `.b` (which inherits from grammar a) and is dependent on `demoA` 
* `demo/demoC`: uses grammar `.c` (which inherits from grammar a) and is dependent on `demoC` 

[![Build Status](https://travis-ci.org/tmtron/ex.xtext.ml.svg?label=travis)](https://travis-ci.org/tmtron/ex.xtext.ml/builds) 

## Building the DSL: 

in the `dsl` folder execute `gradlew build install` - it will install the projects to the local maven repository

## Building the Demo project
in the `demo` folder, execute `gradlew build`

