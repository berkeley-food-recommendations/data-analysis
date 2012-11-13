data-analysis
=============

Data analysis scripts for the project

Pig
---

```sh
$ brew install pig
```

Be sure to drop `JAVA_HOME` into your shell configuration:

```sh
export JAVA_HOME=$(/usr/libexec/java_home)
```

Get the `google-gson` jar (http://code.google.com/p/google-gson/) and place it in the `lib/` directory of this project.
Get the Apache `commons-logging` jar (http://commons.apache.org/logging/) and place it in the `lib/` directory of this project.

Set up your Pig CLASSPATH. Having used `brew` to install `pig`, I ran

```sh
export PIG_CLASSPATH="/usr/local/Cellar/pig/0.10.0/pig-0.10.0-withouthadoop.jar"
export PIG_CLASSPATH="$PIG_CLASSPATH:`pwd`/lib/gson-2.2.2.jar"
export PIG_CLASSPATH="$PIG_CLASSPATH:`pwd`/lib/commons-logging-1.1.1.jar"
```
