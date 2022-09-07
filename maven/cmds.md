CMD

===

## Basic Cmd

```shell
mvn --version

## Skip tests
mvn clean package -Dmaven.test.skip=true
mvn clean package -DskipTests

## Copies dependencies from remote Maven repositories to your local Maven repository.
mvn dependency:copy-dependencies

## Cleans project and copies dependencies from remote Maven repositories to your local Maven repository.
mvn clean dependency:copy-dependencies

## Cleans project, copies dependencies from remote Maven repositories to your local Maven repository and packages your project.
mvn clean dependency:copy-dependencies package

## Prints out the dependency tree for your project - based on the dependencies configured in the pom.xml file.
mvn dependency:tree

## Prints out the dependency tree for your project - based on the dependencies configured in the pom.xml file. Includes repeated, transitive dependencies.
mvn dependency:tree -Dverbose

## Prints out the dependencies from your project which depend on the com.fasterxml.jackson.core artifact.
mvn dependency:tree -Dincludes=com.fasterxml.jackson.core

## Prints out the dependencies from your project which depend on the com.fasterxml.jackson.core artifact. Includes repeated, transitive dependencies.
mvn dependency:tree -Dverbose -Dincludes=com.fasterxml.jackson.core

## Prints out the classpath needed to run your project (application) based on the dependencies configured in the pom.xml file.
mvn dependency:build-classpath

## Determine File Location
mvn -X clean | grep "settings"

## Determine Effective Settings
mvn help:effective-settings

## Override the Default Location
### Maven also allows us to override the location of the global and user settings via the command line:
mvn clean --settings c:\user\user-settings.xml --global-settings c:\user\global-settings.xml
### We can also use the shorter –s version of the same command:
mvn clean --s c:\user\user-settings.xml --gs c:\user\global-settings.xml

## This command tells maven to run parallel builds using the specified thread count. It’s useful in multiple module projects where modules can be built in parallel. It can reduce the build time of the project.
mvn -T 4 package

## This command is used to run the maven build in the offline mode. It’s useful when we have all the required JARs download in the local repository and we don’t want Maven to look for any JARs in the remote repository.
mvn -o package

## Runs the maven build in the quiet mode, only the test cases results and errors are displayed.
mvn -q package

## This command is used to build a project from a different location. We are providing the pom.xml file location to build the project. It’s useful when you have to run a maven build from a script.
mvn -f maven-example-jar/pom.xml package

```


```shell
## 实战
mvn help:effective-settings --s ~/.m2/cmss.xml --gs /usr/local/maven-3.6.1/conf/global.xml
mvn -f ./pom.mod.xml -Dmaven.test.skip=true --s ~/.m2/cmss.xml --gs /usr/local/maven-3.6.1/conf/global.xml clean install
mvn -f ./pom.mod.xml -Dmaven.test.skip=true --s ~/.m2/cmss.xml --gs /usr/local/maven-3.6.1/conf/global.xml dependency:tree -Dverbose
mvn -Dmaven.test.skip=true --s ~/.m2/cmss.xml --gs /usr/local/maven-3.6.1/conf/global.xml clean install
mvn -Dmaven.test.skip=true --s ~/.m2/cmss.xml --gs /usr/local/maven-3.6.1/conf/global.xml dependency:tree -Dverbose
```

## Creating a Project

```shell
## You need somewhere for your project to reside. Create a directory somewhere and start a shell in that directory. On your command line, execute the following Maven goal:
mvn archetype:generate \
    -DgroupId=com.mycompany.app \
    -DartifactId=my-app \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 \
    -DinteractiveMode=false


## Build the project
mvn package

## You may test the newly compiled and packaged JAR with the following command
java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App

```

## Java 9 or later

By default your version of Maven might use an old version of the maven-compiler-plugin that is not compatible with Java 9 or later versions. To target Java 9 or later, you should at least use version 3.6.0 of the maven-compiler-plugin and set the maven.compiler.release property to the Java release you are targetting (e.g. 9, 10, 11, 12, etc.).

In the following example, we have configured our Maven project to use version 3.8.1 of maven-compiler-plugin and target Java 11

```xml
    <properties>
        <maven.compiler.release>11</maven.compiler.release>
    </properties>
 
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.8.1</version>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
```

## Running Maven Tools

Although hardly a comprehensive list, these are the most common default lifecycle phases executed.

* validate: validate the project is correct and all necessary information is available
* compile: compile the source code of the project
* test: test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed
* package: take the compiled code and package it in its distributable format, such as a JAR.
* integration-test: process and deploy the package if necessary into an environment where integration tests can be run
* verify: run any checks to verify the package is valid and meets quality criteria
* install: install the package into the local repository, for use as a dependency in other projects locally
* deploy: done in an integration or release environment, copies the final package to the remote repository for sharing with other developers and projects.

There are two other Maven lifecycles of note beyond the default list above. They are

* clean: cleans up artifacts created by prior builds
* site: generates site documentation for this project
