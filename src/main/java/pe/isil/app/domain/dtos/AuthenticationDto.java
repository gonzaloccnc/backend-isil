package pe.isil.app.domain.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder @Data @AllArgsConstructor @NoArgsConstructor
public class AuthenticationDto {
    private String token;
    private boolean ok;
    private String message;
}
