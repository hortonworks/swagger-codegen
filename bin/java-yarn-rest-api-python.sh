#!/bin/sh
SCRIPT="$0"
while [ -h "$SCRIPT" ] ; do
  ls=`ls -ld "$SCRIPT"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    SCRIPT="$link"
  else
    SCRIPT=`dirname "$SCRIPT"`/"$link"
  fi
done
if [ ! -d "${APP_DIR}" ]; then
  APP_DIR=`dirname "$SCRIPT"`/..
  APP_DIR=`cd "${APP_DIR}"; pwd`
fi
executable="./modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
if [ ! -f "$executable" ]
then
  mvn clean package
fi
# if you've executed sbt assembly previously it will use that instead.
export JAVA_OPTS="${JAVA_OPTS} -XX:MaxPermSize=256M -Xmx1024M -DloggerPath=conf/log4j.properties"
#file="YARN-Simplified-API-Layer-For-Services-v0.yaml"
file="YARN-Simplified-V1-API-Layer-For-Services.yaml"
#ags="$@ generate -i "https://raw.githubusercontent.com/hortonworks/ycloud/master/api/dash/swagger-to-pdf/YARN-Simplified-API-Layer-For-Services-v0.yaml?token=AEApw4vVMsQTYFG9RHlJXliHApb4K8B_ks5XEaPmwA%3D%3D" -l python -o samples/client/slider/python/default --model-package org.apache.slider.rest.v2.resource --api-package org.apache.slider.rest.v2.api --invoker-package org.apache.slider.rest.v2.client --group-id org.apache.slider --artifact-id slider-rest --artifact-version 2.0.0"
ags="$@ generate -i $file -l python -o /Users/sdevineni/git/releng/pyyarn --config pyyarn.json"
echo "java $JAVA_OPTS -jar $executable $ags"
java $JAVA_OPTS -jar $executable $ags
