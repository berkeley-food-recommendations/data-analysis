SPACE = ' '

CP = $(PIG_CLASSPATH):lib/commons-logging-1.1.1.jar:lib/gson-2.2.2.jar

JFLAGS = -g -cp $(CP)
JC = javac

SOURCES = $(wildcard berkeleyfoodudfs/*.java)
CLASSES = $(SOURCES:.java=.class)
JAR = berkeleyfoodudfs.jar

default: compile

compile: classes jar

$(CLASSES):
	$(JC) $(JFLAGS) $(SOURCES)

classes: $(CLASSES)

jar: $(CLASSES)
	jar cvf $(JAR) $(CLASSES)

clean:
	$(RM) $(CLASSES)
	$(RM) $(JAR)
