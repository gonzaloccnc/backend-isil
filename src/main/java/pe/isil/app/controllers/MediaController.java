package pe.isil.app.controllers;

import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import pe.isil.app.domain.enums.Storage;
import pe.isil.app.services.FileService;

import java.io.IOException;
import java.nio.file.Files;

@Controller
@RequestMapping("/media")
@RequiredArgsConstructor
public class MediaController {

  private final FileService fileService;

  @GetMapping("/contents/{filename}")
  ResponseEntity<Resource> getContent(@PathVariable String filename) throws IOException {
    Resource resource = fileService.loadAsResource(filename, Storage.CONTENTS);
    String contentType = Files.probeContentType(resource.getFile().toPath());

    return ResponseEntity
        .ok()
        .header("Content-Type", contentType)
        .body(resource);
  }
}
