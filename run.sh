#!/bin/sh
mvn install:install-file -Dfile=libs/activejdbc-1.4.9-tobykurien-2.jar -DgroupId=org.javalite -DartifactId=activejdbc-tobykurien-2 -Dversion=1.4.9 -Dpackaging=jar
mvn install:install-file -Dfile=libs/sparkler_v0.0.3.jar -DgroupId=com.tobykurien -DartifactId=sparkler -Dversion=0.0.3 -Dpackaging=jar
mvn compile

