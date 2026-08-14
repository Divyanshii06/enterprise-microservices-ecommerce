#!/usr/bin/env bash
set -euo pipefail

ROOT="enterprise-distributed-ecommerce-backend"
mkdir -p "$ROOT"
cd "$ROOT"

echo "Creating module folders..."
for m in api-gateway auth-service product-service order-service common-dtos; do
  mkdir -p "$m"/src/main/java
  mkdir -p "$m"/src/main/resources
  mkdir -p "$m"/src/test/java
done

cat > pom.xml <<'POM'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.ecommerce</groupId>
  <artifactId>enterprise-distributed-ecommerce-backend</artifactId>
  <version>0.1.0</version>
  <packaging>pom</packaging>
  <name>enterprise-distributed-ecommerce-backend</name>
  <properties>
    <java.version>17</java.version>
    <spring.boot.version>3.1.4</spring.boot.version>
  </properties>
  <modules>
    <module>api-gateway</module>
    <module>auth-service</module>
    <module>product-service</module>
    <module>order-service</module>
    <module>common-dtos</module>
  </modules>
  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>${spring.boot.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>
</project>
POM

echo "Scaffold created. Edit individual module poms and sources as needed."

echo "Done."
