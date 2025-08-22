# Build extension
#FROM maven:3.8.5-openjdk-17 as buildext
#
#COPY . /build
#WORKDIR /build
#RUN mvn clean install

# Add Extension to Keyclock server
FROM keycloak/keycloak:25.0.6

#COPY --from=buildext /build/target/suvera-keycloak-scim2-outbound-provisioning-jar-with-dependencies.jar /opt/keycloak/providers/
COPY target/suvera-keycloak-scim2-outbound-provisioning-jar-with-dependencies.jar /opt/keycloak/providers/

RUN /opt/keycloak/bin/kc.sh build

ENV KEYCLOAK_ADMIN=admin \
    KEYCLOAK_ADMIN_PASSWORD=admin \
    KC_FEATURES=preview \
    KC_HOSTNAME=jheni-keycloak.duckdns.org \
    KC_PROXY=edge \
    KC_SPI_SCIM_USER_ATTRIBUTE_MAPPINGS_0_SCIM_ATTRIBUTE=displayName \
    KC_SPI_SCIM_USER_ATTRIBUTE_MAPPINGS_0_KEYCLOAK_ATTRIBUTE=displayName \
    KC_SPI_SCIM_USER_ATTRIBUTE_MAPPINGS_0_READONLY=false \
    KC_SPI_THEME_WELCOME_THEME=scim \
    KC_HTTP_ENABLED=true \
    KC_HTTPS_CERTIFICATE_FILE=/certs/fullchain1.pem \
    KC_HTTPS_CERTIFICATE_KEY_FILE=/certs/privkey1.pem \
    KC_SPI_REALM_RESTAPI_EXTENSION_SCIM_LICENSE_KEY=""

EXPOSE 8080/tcp
EXPOSE 8443/tcp
EXPOSE 9000/tcp

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
