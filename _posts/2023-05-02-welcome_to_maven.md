---
layout: single
title: Welcome to Maven
date: 2023-05-02
tag: maven tutorial newbie
---

# Intro to Maven 

Maven is a build, packaging utility that is wiedly adopted. I have known about it for a long time but never really had a need or wanted to learn. That changed TODAY!. I come from a Java developer and ANT background, with a lot of expertize in Eclipse.

There lots of tutorial out there in the web that explain how to build a Hello world sample, I started with this one from Spring.io [https://spring.io/guides/gs/maven/](https://spring.io/guides/gs/maven/) I liked it because it was very simple to folllow. As I completed the tutorial and I used 'mvn compile' things didn't work and that is were my adventure for this blog post starts... where did I go wrong? is the tutorial wrong? did I miss a step? and also where is this compile target, in ant we have Target tasks, so where is the compile target?

# Changing the maven default src path

I love Eclipse, I been with it since its begining when I had to download it as a Alpha release and Learn it because it was the next thing that my team was going to be supporting. Up to this day I still like it better than some of the old java IDE predecesors. 

Because I have started this tutorial with a Simple Java project in Eclipse, the structure of the files do not follow the maven convention of 'src/main/java/hello' so Maven didn't know what to build. After lots of research I found I can add to the build section before the <plugin> tag but after the <build> one.

```
        <resources>
        	<resource>
          		<directory>src/</directory>
        	</resource>
     	</resources>
```

That helped to get the code compiled. But where is the compile target, I still do not understand how I can add dependancies and why is there a section called plugin that seems to be the doing the packaging?

# Breaking down the pom.xml

The pom.xml is the main file for Maven, it is used to defined how to compile the app, how to package, what to build and include, how to test it, how to deploy it, in other words IT IS THE FILE!, you know. 

## Definition 
To understand it better, POM stands for Project Object Modeler which helps understand why it is the ONE file that has everything for your project. It defines the project in a object way, if that makes sense. Thus in this file you will find all sorts of tags that help provide the definition of the project:

- What is the name of the project
- What version 
- Where is the source of the project
- Is the source in 1.8 java
- What compiler version do we want to use?
- Where is the unit test?
- How to package the code
- ...

### So what we know about POM so far?

- They are the one file that defines your project as an object, with its properties. 
- They contain all information required to compile, test and deploy the project, if nedeed

## Inheritance
 Let introduce now the concept of inheritance. POM.xml have inheritance, meaning that you can have child pom.xml, in fact if you have only one single pom.xml in a "round about way" that one pom.xml is already a child pom because there are are properties defined by default or as maven calls it the [Super POM](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html#super-pom). Properties that you don't define in your file it will use its defaults ones in the Super POM, you can find the Super POM at: [maven.apache.org/ref/3.6.3/maven-model-builder/super-pom.html](https://maven.apache.org/ref/3.6.3/maven-model-builder/super-pom.html)
 
 To apply a practical example, let's look at a scenario of creating a simple java project in eclipse. I created a pom.xml to go along with my simple java project to use maven. In my pom.xml, the path to find where the java source is defined is not defined anywhere, so maven then finds it from the Super POM, the elements that is in use here is <sourceDirectory>. In the Super POM the <sourceDirectory> points to a different directory than the one that eclipse uses for Java projects. In Eclipse we use `/src` and in maven it wants to be using `/src/main/java`. I am aware that there is a option to create a Maven Java Project but I decided to not use that.

The important section of the pom.xml related to the path is below, and I have also added the complete pom.xml file with added comments to explain the basic lines. Lets look into the the <build> section, and lets skip over all the details until next section subtitle, for now lets keep it simple. To configure maven to find the source file in a different directory I added the following one line to my pom.xml, you can refer to the entire pom.xml in the section below to see where is added:

```
           <sourceDirectory>src/</sourceDirectory>
```

This tells maven where to find the source of the files to compile. The directory is relative to where the pom.xml file is located. If we do not define this property or overwrite it in our pom.xml it would had used the one from the super-pom.xml.

Our complete pom.xml looks like: 

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <!-- Group or organization that the project belongs to, change this to your com.own.company -->
    <groupId>com.hcl.commerce.avera</groupId>
    
    <!-- name/id of the project -->
    <artifactId>maven_tutorial</artifactId>
    
    <!-- The artifact that is being built -->
    <packaging>jar</packaging>
    
    <!-- Version number of this project -->
    <version>0.0.1</version>

    <!-- Other properties that can be defined, the example shows that you need java 1.8 to com -->
    <properties>
        <maven.compiler.source>1.8</maven.compiler.source>
        <maven.compiler.target>1.8</maven.compiler.target>
    </properties>


    <build>
       <sourceDirectory>src/</sourceDirectory> <!-- Added so that maven knows that were are using eclipse source directory -->
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>3.2.4</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                        <configuration>
                            <transformers>
                                <transformer
                                    implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                    <mainClass>hello.HelloWorld</mainClass>
                                </transformer>
                            </transformers>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

</project>
```

# The maven phases (The build lifecycle)

In the previous section we glanced over the build section to look into the build > sourceDirectory section to explain the inheritance and show how if a property is not there, it uses the from defined by its parent or the default. This will become more applicable as you move forward and have to define yourself with child pom.xml. Let me now introduce you to the basic lifecycle.

According to [The maven docs](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html) there are 7 phases predefined already, `build` is not one of them, and this really threw me off, but I think this is a me problem.

   1. validate - validate the project is correct and all necessary information is available
   1. compile - compile the source code of the project
   1. test - test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed
   1. package - take the compiled code and package it in its distributable format, such as a JAR.
   1. verify - run any checks on results of integration tests to ensure quality criteria are met
   1. install - install the package into the local repository, for use as a dependency in other projects locally
   1. deploy - done in the build environment, copies the final package to the remote repository for sharing with other developers and projects.

Each of this can be called invdividually when doing a mvn to build the project. Just doing `mvn` will give you an error as you didn't specify a goal or phase. In the sample above you will have to call mvn so that it goes through the steps phase that you need it to, in our case if we want to confirm the build of the java files, then you want to call: `mvn compile` DUH! build=compile... so in fact all the phases make a lot of sense when you sit down and think about it. If you want to have the jar version then `mvn package`, and etc.

With this I conclude my introduction to maven project. I think maven is a great tool to build java projects but at first it can be quiet hard to think on this organized way, but this goes back to the basic of Software Engineering which was part of my 400 courses when I was in university. 


