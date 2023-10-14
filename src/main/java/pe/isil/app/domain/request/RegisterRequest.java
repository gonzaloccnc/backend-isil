package pe.isil.app.domain.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class RegisterRequest {
  private String firstname;
  private String surnames;
  private String email;
  private String password;
  private String docId;
  private int typeDoc;
}
