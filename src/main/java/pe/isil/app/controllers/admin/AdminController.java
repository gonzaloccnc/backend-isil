package pe.isil.app.controllers.admin;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import pe.isil.app.domain.dtos.ClassroomDto;
import pe.isil.app.domain.dtos.ErrorDto;
import pe.isil.app.domain.dtos.MonoDto;
import pe.isil.app.domain.dtos.PageableDto;
import pe.isil.app.domain.models.Classroom;
import pe.isil.app.domain.models.Course;
import pe.isil.app.domain.models.User;
import pe.isil.app.domain.repos.IClassroomRepo;
import pe.isil.app.domain.repos.IClassroomViewRepo;
import pe.isil.app.domain.repos.ICourseRepo;
import pe.isil.app.domain.repos.IUserRepo;
import pe.isil.app.domain.utils.PageableUtil;

import java.util.List;
import java.util.UUID;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {

  private final ICourseRepo courseRepo;
  private final IUserRepo userRepo;
  private final IClassroomRepo classroomRepo;
  private final IClassroomViewRepo classroomViewRepo;

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

  @GetMapping(value = "/courses/{id}")
  ResponseEntity<?> getOneCourse(@PathVariable String id, HttpServletRequest req) {
    var existCourse = courseRepo.findById(id).orElse(null);

    if(existCourse == null) {
      return ResponseEntity.status(404).body(
          ErrorDto.builder()
              .url(req.getRequestURI())
              .ok(false)
              .status(404)
              .error(HttpStatus.NOT_FOUND.getReasonPhrase())
              .message("El curso no existe")
              .build()
      );
    }

    return ResponseEntity.ok(
        MonoDto.<Course>builder()
            .data(existCourse)
            .ok(true)
            .status(200)
            .message("Curso encontrado")
            .build()
    );
  }

  @GetMapping("/courses/name/{name}")
  ResponseEntity<?> getCourseByName(
      @PathVariable String name,
      @PageableDefault(size = 20) Pageable pageable,
      HttpServletRequest req
  ) {
    var existCourse = courseRepo.findCourseByCourseNameContains(pageable, name);

    if(existCourse.getNumber() >= existCourse.getTotalPages() & existCourse.getTotalPages() != 0) {
      return ResponseEntity.status(400).body(
          PageableDto
              .<List<Course>>builder()
              .ok(false)
              .message(
                  "El contenido de la pagina debe ser menor a " + existCourse.getTotalPages()
              )
              .build()
      );
    }

    var next = PageableUtil.getNextPage(existCourse);
    var prev = PageableUtil.getPrevPage(existCourse);

    return ResponseEntity.ok(
        PageableDto.builder()
            .data(existCourse.getContent())
            .hints(existCourse.getTotalElements())
            .page(existCourse.getNumber())
            .pageSize(existCourse.getSize())
            .totalPages(existCourse.getTotalPages())
            .prev(prev == null ? null : PageableUtil.getDomain(req) + prev)
            .next(next == null ? null : PageableUtil.getDomain(req) + next)
            .ok(true)
            .build()
    );
  }

  @PostMapping("/classes")
  ResponseEntity<?> addClass(@RequestBody Classroom classroom, HttpServletRequest req) {
    var admin = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

    var existCourse = courseRepo.findById(classroom.getIdCourse()).orElse(null);
    var existTeacher = userRepo.findById(classroom.getIdTeacher()).orElse(null);
    var isTeacher = existTeacher != null && existTeacher.getUserType() == 2;

    if(existCourse == null || !isTeacher) {
      return ResponseEntity.status(404).body(
          ErrorDto.builder()
              .status(404)
              .url(req.getRequestURI())
              .error(HttpStatus.NOT_FOUND.getReasonPhrase())
              .ok(false)
              .message("El curso no existe o el idTeacher no es un profesor")
              .build()
      );
    }

    classroom.setIdClassroom(UUID.randomUUID().toString());
    classroom.setUserCreation(admin.getIdUser());

    var classroomSave = classroomRepo.save(classroom);
    var classView = classroomViewRepo.findByIdClassroom(classroomSave.getIdClassroom());

    return ResponseEntity.ok(
     MonoDto.builder()
         .data(classView)
         .status(201)
         .ok(true)
         .message("Clase creada correctamente")
         .build()
    );
  }

  @PatchMapping("/classes/{id}")
  ResponseEntity<?> updateClass(
      @PathVariable String id,
      @RequestBody Classroom classroom,
      HttpServletRequest req
  ) {
    var admin = (User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    var existCourse = courseRepo.findById(classroom.getIdCourse()).orElse(null);
    var existTeacher = userRepo.findById(classroom.getIdTeacher()).orElse(null);
    var isTeacher = existTeacher != null && existTeacher.getUserType() == 2;
    var existClass = classroomRepo.findById(id).orElse(null);

    if(existClass == null) {
      return ResponseEntity.status(404).body(
          ErrorDto.builder()
              .status(404)
              .url(req.getRequestURI())
              .error(HttpStatus.NOT_FOUND.getReasonPhrase())
              .ok(false)
              .message("El curso con id: " + id + " no existe")
              .build()
      );
    }


    if(existCourse == null || !isTeacher) {
      return ResponseEntity.status(404).body(
          ErrorDto.builder()
              .status(404)
              .url(req.getRequestURI())
              .error(HttpStatus.NOT_FOUND.getReasonPhrase())
              .ok(false)
              .message("El curso no existe o el idTeacher no es un profesor")
              .build()
      );
    }

    classroom.setIdClassroom(id);
    classroom.setUserCreation(existClass.getUserCreation());
    classroom.setUserUpdating(admin.getIdUser());

    var classroomSave = classroomRepo.save(classroom);
    var classView = classroomViewRepo.findByIdClassroom(classroomSave.getIdClassroom());

    return ResponseEntity.ok(
        MonoDto.builder()
            .data(classView)
            .status(201)
            .ok(true)
            .message("Clase actualizada correctamente")
            .build()
    );
  }

  @GetMapping("/classes/{id}")
  ResponseEntity<?> getOneClass(@PathVariable String id, HttpServletRequest req) {

    var classFind = classroomRepo.findById(id).orElse(null);

    if(classFind == null) {
      return ResponseEntity.status(404).body(
        ErrorDto.builder()
            .url(req.getRequestURI())
            .ok(false)
            .status(404)
            .error(HttpStatus.NOT_FOUND.getReasonPhrase())
            .message("No existe la clase")
            .build()
      );
    }

    return ResponseEntity.ok(
        MonoDto.<ClassroomDto>builder()
            .data(classFind.toDto())
            .status(200)
            .message("Clase encontrada")
            .ok(true)
            .build()
    );
  }

  @GetMapping("/classes/name/{name}")
  ResponseEntity<?> getClassByName(
      @PathVariable String name,
      @PageableDefault(size = 20) Pageable pageable,
      HttpServletRequest req
  ) {

    var classFind = classroomViewRepo.findAllByCourseContains(pageable, name);

    if (classFind.getNumber() >= classFind.getTotalPages() & classFind.getTotalPages() != 0) {
      return ResponseEntity.status(400).body(
          PageableDto
              .<List<Course>>builder()
              .ok(false)
              .message(
                  "El contenido de la pagina debe ser menor a " + classFind.getTotalPages()
              )
              .build()
      );
    }

    var next = PageableUtil.getNextPage(classFind);
    var prev = PageableUtil.getPrevPage(classFind);

    return ResponseEntity.ok(
        PageableDto.builder()
            .data(classFind.getContent())
            .hints(classFind.getTotalElements())
            .page(classFind.getNumber())
            .pageSize(classFind.getSize())
            .totalPages(classFind.getTotalPages())
            .prev(prev == null ? null : PageableUtil.getDomain(req) + prev)
            .next(next == null ? null : PageableUtil.getDomain(req) + next)
            .ok(true)
            .build()
    );
  }
}
