FROM maven:3.5.4-jdk-11-slim as build-stage
WORKDIR /function
ENV MAVEN_OPTS -Dhttp.proxyHost= -Dhttp.proxyPort= -Dhttps.proxyHost= -Dhttps.proxyPort= -Dhttp.nonProxyHosts= -Dmaven.repo.local=/usr/share/maven/ref/repository
ADD pom.xml /function/pom.xml
ADD src /function/src
RUN ["mvn", "package", \
            "dependency:copy-dependencies", \
	    "-DincludeScope=runtime", \
	    "-Dmdep.prependGroupId=true", \
	    "-DoutputDirectory=target" ]



FROM openjdk:11-jdk-slim
WORKDIR /function
RUN ["/usr/bin/java", "-Xshare:dump"]

COPY --from=build-stage /function/target/*.jar /function/app/

ENTRYPOINT [ "/usr/bin/java", \
                "-XX:+UseSerialGC", \
		"-Xshare:on", \
		"-cp", "/function/app/*", \
		"com.fnproject.fn.runtime.EntryPoint" ]

CMD ["com.example.fn.HelloFunction::handleRequest"]
