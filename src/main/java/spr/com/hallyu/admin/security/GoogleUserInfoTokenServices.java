package spr.com.hallyu.admin.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.oauth2.client.OAuth2RestOperations;
import org.springframework.security.oauth2.client.OAuth2RestTemplate;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.OAuth2Request;
import org.springframework.security.oauth2.provider.token.ResourceServerTokenServices;

import java.util.Collections;
import java.util.Map;

@SuppressWarnings("unchecked")
public class GoogleUserInfoTokenServices implements ResourceServerTokenServices {

    private final String userInfoUri;
    private final String clientId;
    private OAuth2RestOperations restTemplate;

    public GoogleUserInfoTokenServices(String userInfoUri, String clientId) {
        this.userInfoUri = userInfoUri;
        this.clientId = clientId;
    }

    public void setRestTemplate(OAuth2RestOperations restTemplate) {
        this.restTemplate = restTemplate;
    }

    @Override
    public org.springframework.security.oauth2.common.OAuth2AccessToken readAccessToken(String accessToken) {
        throw new UnsupportedOperationException("Not supported: readAccessToken");
    }

    @Override
    public OAuth2Authentication loadAuthentication(String accessToken) {
        OAuth2RestOperations r = this.restTemplate;
        if (r == null) {
            throw new IllegalStateException("OAuth2RestTemplate is required");
        }
        Map<String, Object> map = r.getForObject(this.userInfoUri, Map.class);

        // 구글 OIDC userinfo 표준 필드
        String userId = (String) map.getOrDefault("sub", map.get("id"));
        String email = (String) map.get("email");
        String name  = (String) map.getOrDefault("name", email != null ? email : userId);

        // 권한은 필요에 맞게 부여 (예: ADMIN 배정은 별도 룰로)
        AbstractAuthenticationToken user = new AbstractAuthenticationToken(
                AuthorityUtils.commaSeparatedStringToAuthorityList("ROLE_USER")) {
            @Override public Object getCredentials() { return "N/A"; }
            @Override public Object getPrincipal() { return email != null ? email : userId; }
        };
        user.setDetails(map);
        user.setAuthenticated(true);

        // clientId 등 요청 메타
        OAuth2Request req = new OAuth2Request(Collections.emptyMap(), this.clientId, null,
                true, Collections.singleton("read"), null, null, null, null);

        return new OAuth2Authentication(req, user);
    }
}
