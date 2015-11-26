```
echo " Ensure that you have the following installed:"
echo "          sudo"
echo "          gcc"
echo "          rpm"
echo "          rpm-build"
echo "          libidn"
echo "          curl"
echo "          fetchmail"
echo "          ant-1.6.5"
echo "          Sun Java Development Kit 1.5.0_04"
echo ""

USE="java ldap idn jikes javamail jce"
```

log4j ~x86

gnu-crypto won't compile ~x86 it (1.5.0 patch)

add package.keywords: dev-java/ant dev-java/ant-tasks dev-java/ant-core
unmask sun-jdk
emerge -av dev-java/sun-jdk app-admin/sudo rpm fetchmail curl dev-java/ant

copy some DEF file to UNKNOWN.def
