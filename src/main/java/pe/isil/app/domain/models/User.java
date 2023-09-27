package pe.isil.app.domain.models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import pe.isil.app.domain.enums.Rol;

import java.time.LocalDate;
import java.util.*;

@Entity(name = "users") @Data
@Builder @AllArgsConstructor @NoArgsConstructor
public class User implements UserDetails {

    @Id
    private String idUser;

    private String firstname;
    private String surnames;
    private LocalDate birthday;
    private String address;
    private String docId;
    private int typeDoc;
    private String password;
    private String email;
    private String phone;
    private LocalDate registerDate;
    private int state;
    private int userType;
    private String photo;
    private String idCareer;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();

        switch (userType) {
            case 1:
                authorities.add(new SimpleGrantedAuthority(Rol.ADMIN.name()));
                break;
            case 2:
                authorities.add(new SimpleGrantedAuthority(Rol.PROFESOR.name()));
                break;
            case 3:
                authorities.add(new SimpleGrantedAuthority(Rol.ALUMNO.name()));
                break;
            default:
                authorities.add(new SimpleGrantedAuthority(Rol.NULL.name()));
                break;
        }

        return authorities;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
