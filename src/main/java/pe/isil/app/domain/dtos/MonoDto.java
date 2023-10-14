package pe.isil.app.domain.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder @Data @AllArgsConstructor @NoArgsConstructor
public class MonoDto<T> {
  private T data;
  private String message;
  private boolean ok;
  private int status;
}
