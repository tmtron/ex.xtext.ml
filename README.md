# Testproject for Xtext with multiple grammars

The repository contains multiple xtext projects:

*  [mla](dsl/mla): grammar a which is independent
*  [mlb](dsl/mlb): grammar b, which inherits from grammar a
*  [mlc](dsl/mlc): grammar c, which inherits from grammar b

and simple demo-project that use the grammars and have each a very simple model file:
* [demoA](demo/demoA): uses grammar `mla` (which is independent)
* [demoB](demo/demoB): uses grammar `mlb` (which inherits from grammar mla) and is dependent on `demoA` 
* [demoC](demo/demoC): uses grammar `mlc` (which inherits from grammar mlb) and is dependent on `demoC` 

[![Build Status](https://travis-ci.org/tmtron/ex.xtext.ml.svg?label=travis)](https://travis-ci.org/tmtron/ex.xtext.ml/builds) 

## Building the DSL: 

in the `dsl` folder execute `gradlew build install` - it will install the projects to the local maven repository

## Building the Demo project
in the `demo` folder, execute `gradlew build`

# Xtext notes

## Inheriting from a grammar

For example [mlb](dsl/mlb) inherits from [mla](dsl/mla).

The [gradle build file](dsl/mlb/build.gradle#L11) in `mlb` must declare a dependency on `mla`

```gradle
group = 'com.tmtron.ex.xtext.mlb'

dependencies {
    // OTHER DEPENDENCIES
    compile project(':mla')
}
```

In the [mwe2 workflow file](dsl/mlb/src/main/java/com/tmtron/ex/xtext/mlb/GenerateDslB.mwe2#L29) we must mention the referenced Ecore model:

```mwe2
Workflow {
    language = StandardLanguage {
        referencedResource = "platform:/resource/mla/model/generated/DslA.genmodel"
```

In the [xtext file](dsl/mlb/src/main/java/com/tmtron/ex/xtext/mlb/DslB.xtext#L1) we inherit from `DslA`:
```xtext
grammar com.tmtron.ex.xtext.mlb.DslB with com.tmtron.ex.xtext.mla.DslA 

generate dslB "http://www.tmtron.com/ex/xtext/mlb/DslB"

import "http://www.tmtron.com/ex/xtext/mla/DslA" as dsla
```

# Demo project notes

## Using an xtext language

`demoA` wants to use [DslA](dsl/mla). 

### xtext-gradle-plugin
We use the [xtext-gradle-plugin](https://plugins.gradle.org/plugin/org.xtext.builder) which will configure the gradle build and start the xtext-generator.

First we make the xtext-gradle-plugin available to the gradle build: in the [parent build.gradle](demo/build.gradle#L9) file:
```gradle
buildscript {
	repositories {
		jcenter()
	}
	dependencies {
		classpath 'org.xtext:xtext-gradle-plugin:1.0.20'
	}
}
```

Then we can use and configure the xtext-gradle-plugin in the [build.gradle](demo/demoA/build.gradle) file of `demoA`:
```gradle
apply plugin: 'org.xtext.builder'

dependencies {
    xtextLanguages 'com.tmtron.ex.xtext.mla:mla:1.0.0-SNAPSHOT'
}

xtext {
    version = "$xtextVersion"
    languages {
        dsla {
            setup = 'com.tmtron.ex.xtext.mla.DslAStandaloneSetup'
            generator {
                outlet.producesJava = true
            }
        }
    }
```

Now we can simply create a model file, with the correct file extension: [modelA.dsla](demo/demoA/src/main/java/com/tmtron/modelA.dsla) and start the gradle build.  
The xtext-gradle-plugin will start our generator before the java compilation and infer the correct classpath.

## Using a model from another project

For example [demoB](demo/demoB) uses the model from [demoA](demo/demoA).

### Prepare demoA

`demoB` needs to read [modelA.dsla](demo/demoA/src/main/java/com/tmtron/modelA.dsla). Thus we must make sure that the model file ends up in the generated `.jar` file.  
We can simply add the java source dir to the build resources in the [gradle build file of demoA](demo/demoA/build.gradle#L8):
```gradle
// we must also export the model because the other project/s will refer to it
sourceSets.main.resources.srcDirs += ["src/main/java"]
```

### Configure demoB
In the [gradle.build](demo/demoB/build.gradle#L4) file of `demoB` we must declare a dependency to `demoA`, because we need access to [modelA.dsla](demo/demoA/src/main/java/com/tmtron/modelA.dsla) (and we may also need some java files from `demoA`)
```gradle
dependencies {
    compile project(':demoA')
```
The language configuration is the same as described in the previous section.  
Now we can create a [modelB.dslb](demo/demoB/src/main/java/modelB.dslb) file and import/use definitions from [modelA.dsla](demo/demoA/src/main/java/com/tmtron/modelA.dsla): 
```java
package com.tmtron.ex.dslb

import com.tmtron.ex.dsla.*

def fieldB: String;
ref fieldA;
```

