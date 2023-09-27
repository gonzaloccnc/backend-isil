package pe.isil.app.domain.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @AllArgsConstructor @NoArgsConstructor
public class ErrorDto {
  private String url;
  private String message;
  private String error;
  private int status;
  private boolean ok;
}
