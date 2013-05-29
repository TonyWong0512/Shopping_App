PATH:=${JAVA_HOME}/bin:${PATH}

SRC = $(wildcard *.java)

all: build

build: ${SRC}
	${JAVA_HOME}/bin/javac -Xlint:deprecation ${SRC}
	${JAVA_HOME}/bin/jar cvf ./DataGenerator.jar ./*.class
clean:
	rm -f *.class *.jar
