package pe.isil.app.security;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import pe.isil.app.domain.enums.Rol;
import pe.isil.app.domain.handlers.AuthenticationCustom;

import java.util.Arrays;
import java.util.List;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {

  private final AuthenticationProvider authenticationProvider;
  private final AuthenticationCustom authenticationCustom;
  private final JwtFilter jwtFilter;

  @Bean
  CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(List.of("*"));
    configuration.setAllowedMethods(List.of("*"));
    configuration.setAllowedHeaders(List.of("*"));
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);
    return source;
  }

  @Bean
  public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http
        .cors(c -> {
          c.configurationSource(corsConfigurationSource());
        })
        .csrf(AbstractHttpConfigurer::disable)
        .authorizeHttpRequests(req -> {
          req.requestMatchers("/auth/**").permitAll();
          req.requestMatchers("/admin/**").hasAuthority(Rol.ADMIN.name());
          req.requestMatchers("/teacher/**").hasAuthority(Rol.PROFESOR.name());
          req.requestMatchers("/student/**").hasAuthority(Rol.ALUMNO.name());
          req.anyRequest().authenticated();
        })
        .exceptionHandling(ex -> {
          ex.authenticationEntryPoint(authenticationCustom);
        })
        .sessionManagement(session -> {
          session.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
        })
        .authenticationProvider(authenticationProvider)
        .addFilterBefore(jwtFilter, UsernamePasswordAuthenticationFilter.class);

    return http.build();
  }
}
