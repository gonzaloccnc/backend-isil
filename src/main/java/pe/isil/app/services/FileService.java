package pe.isil.app.services;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.web.multipart.MultipartFile;
import pe.isil.app.domain.enums.Storage;
import pe.isil.app.domain.exceptions.FileNotFoundException;
import pe.isil.app.domain.exceptions.StorageException;

import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@Service
public class FileService {

  @Value("${storage}")
  private String storageLocation;

  private final List<String> extensionsPPT = List.of(
      "application/vnd.ms-powerpoint",
      "application/vnd.openxmlformats-officedocument.presentationml.slideshow",
      "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  );

  @PostConstruct
  public void init() {
    try {
      Files.createDirectories(Paths.get(storageLocation));
    }catch (IOException e){
      throw new StorageException("failed to init", e);
    }
  }

  public String store(MultipartFile file, String id, Storage storage) {
    String filename = file.getOriginalFilename();


    String filenameFinal = id + "-" +  filename;

    try {
      InputStream inputStream = file.getInputStream();
      Files.copy(
          inputStream,
          Paths
              .get(storageLocation + "/" + storage.name().toLowerCase())
              .resolve(filenameFinal), StandardCopyOption.REPLACE_EXISTING
      );
    } catch (IOException e){
      throw new StorageException("Error al guardar el archivo: " + filename, e);
    }

    return filenameFinal;
  }

  public Path load(String filename, Storage storage) {

    return Paths
        .get(storageLocation + "/" + storage.name().toLowerCase())
        .resolve(filename);
  }

  public Resource loadAsResource(String filename, Storage storage) {
    try{
      Path file = load(filename, storage);
      Resource resource = new UrlResource(file.toUri());

      if (resource.exists() || resource.isReadable()){
        return resource;
      }else{
        throw new FileNotFoundException("file not found or cannot be read " + filename);
      }
    }catch (MalformedURLException e){
      throw new FileNotFoundException("file not found or cannot be read " + filename, e);
    }
  }

  public void delete(String filename, Storage storage) {
    try {
      Path file = load(filename, storage);
      FileSystemUtils.deleteRecursively(file);
    }catch (IOException e){
      throw new StorageException("cannot delete file " + filename, e);
    }
  }
}