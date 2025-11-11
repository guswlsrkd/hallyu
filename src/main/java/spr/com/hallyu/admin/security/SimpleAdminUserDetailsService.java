package spr.com.hallyu.admin.security;

import org.springframework.security.core.userdetails.*;
import org.springframework.security.core.authority.AuthorityUtils;

public class SimpleAdminUserDetailsService implements UserDetailsService {
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 임시: admin / {bcrypt}... 으로 하나 만든다고 가정(네 구현으로 교체해도 됨)
        if (!"admin".equals(username)) {
            throw new UsernameNotFoundException(username);
        }
        String encoded = "$2a$10$abcdefghijklmnopqrstuv/2FQf9rTt7aKq3hVQmE3i"; // 임의 값(교체 필요)
        return new User("admin", encoded, true, true, true, true,
                AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
    }
}
