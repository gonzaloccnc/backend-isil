package pe.isil.app.controllers.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.isil.app.domain.dtos.PageableDto;
import pe.isil.app.domain.models.Course;
import pe.isil.app.domain.repos.ICourseRepo;
import pe.isil.app.domain.utils.PageableUtil;

import java.util.List;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

  private final ICourseRepo courseRepo;

  @GetMapping("/courses")
  ResponseEntity<PageableDto<List<Course>>> getCourses(
      @PageableDefault(size = 20, sort = "courseName") Pageable pageable,
      HttpServletRequest req
  ) {
    var courses = courseRepo.findAll(pageable);

    if(courses.getNumber() >= courses.getTotalPages() & courses.getTotalPages() != 0) {
      return ResponseEntity.status(400).body(
          PageableDto
              .<List<Course>>builder()
              .ok(false)
              .message(
                  "El contenido de la pagina debe ser menor a " + courses.getTotalPages()
              )
              .build()
      );
    }

    var next = PageableUtil.getNextPage(courses);
    var prev = PageableUtil.getPrevPage(courses);

    return ResponseEntity.ok(
        PageableDto
            .<List<Course>>builder()
            .data(courses.getContent())
            .hints(courses.getTotalElements())
            .page(courses.getNumber())
            .pageSize(courses.getSize())
            .totalPages(courses.getTotalPages())
            .prev(prev == null ? null : PageableUtil.getDomain(req) + prev)
            .next(next == null ? null : PageableUtil.getDomain(req) + next)
            .ok(true)
            .build()
    );
  }
}
