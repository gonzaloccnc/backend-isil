package pe.isil.app.controllers.user;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.isil.app.domain.dtos.PageableDto;
import pe.isil.app.domain.models.ClassroomView;
import pe.isil.app.domain.repos.IClassroomViewRepo;
import pe.isil.app.domain.utils.PageableUtil;

import java.util.List;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

  private final IClassroomViewRepo classroomViewRepo;

  @GetMapping("/classes")
  ResponseEntity<?> getClasses(
      @PageableDefault(size = 20) Pageable pageable,
      HttpServletRequest req
  ) {
    var classrooms = classroomViewRepo.findAll(pageable);

    if(classrooms.getNumber() >= classrooms.getTotalPages() & classrooms.getTotalPages() != 0) {
      return ResponseEntity.status(400).body(
          PageableDto
              .<ClassroomView>builder()
              .ok(false)
              .message(
                  "El contenido de la pagina debe ser menor a " + classrooms.getTotalPages()
              )
              .build()
      );
    }

    var next = PageableUtil.getNextPage(classrooms);
    var prev = PageableUtil.getPrevPage(classrooms);

    return ResponseEntity.ok(
        PageableDto
            .<List<ClassroomView>>builder()
            .data(classrooms.getContent())
            .hints(classrooms.getTotalElements())
            .page(classrooms.getNumber())
            .pageSize(classrooms.getSize())
            .totalPages(classrooms.getTotalPages())
            .prev(prev == null ? null : PageableUtil.getDomain(req) + prev)
            .next(next == null ? null : PageableUtil.getDomain(req) + next)
            .ok(true)
            .build()
    );
  }

}
