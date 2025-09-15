# ---------- 1단계: 빌드 ----------
FROM maven:3.9.9-eclipse-temurin-11 AS build
WORKDIR /app

# 의존성 먼저 받아 캐시 최적화
COPY pom.xml .
RUN mvn -q -e -B -DskipTests dependency:resolve

# 소스 복사 및 패키징
COPY src ./src
RUN mvn -q -e -B -DskipTests package

# ---------- 2단계: 실행(경량 JRE) ----------
FROM eclipse-temurin:11-jre
WORKDIR /app

# 산출물 복사 (app-jar-with-dependencies.jar → app.jar)
COPY --from=build /app/target/app-jar-with-dependencies.jar /app/app.jar

# 컨테이너 시작 시 실행
ENTRYPOINT ["java","-jar","/app/app.jar"]