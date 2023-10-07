package pe.isil.app.domain.dtos;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import pe.isil.app.domain.models.Course;

import java.util.List;

@Data
@Builder @AllArgsConstructor @NoArgsConstructor
public class PageableDto<T> {
  private T data;
  private boolean ok;
  private String message;
  private String next;
  private String prev;
  private int page;
  private int pageSize;
  private long hints;
  private int totalPages;
}
