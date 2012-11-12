JFLAGS = -g -cp $(PIG_CLASSPATH)
JC = javac
.SUFFIXES: .java .class

.java.class:
	$(JC) $(JFLAGS) $*.java

SOURCES = $(wildcard berkeleyfoodudfs/*.java)
CLASSES = $(SOURCES:.java=.class)

default: classes

classes: $(CLASSES)

clean:
	$(RM) $(CLASSES)
