package pe.isil.app.domain.utils;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.isil.app.domain.dtos.PageableDto;

import java.util.HashMap;
import java.util.Map;

public class PageableUtil {

  public static String getPrevPage(Page<?> page) {
    return page.hasPrevious()
        ? "?page=" + page.previousPageable().getPageNumber() + "&size=" + page.getSize()
        : null;
  }

  public static String getNextPage(Page<?> page) {
    return page.hasNext()
        ? "?page=" + page.nextPageable().getPageNumber() + "&size=" + page.getSize()
        : null;
  }

  public static String getDomain(HttpServletRequest request) {
    return request.getRequestURL().toString();
  }
}
