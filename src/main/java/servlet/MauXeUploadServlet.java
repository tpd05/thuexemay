package servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import dao.MauXeDAO;
import model.MauXe;

@WebServlet("/doitac/themMauXe")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024) // 5MB
public class MauXeUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || !"DOI_TAC".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/dangnhap");
            return;
        }

        int maDoiTac = (Integer) session.getAttribute("maDoiTac");
        String ctx = request.getContextPath();

        try {
            // Extract form fields
            String maChiNhanhStr = request.getParameter("maChiNhanh");
            String hangXe = request.getParameter("hangXe");
            String dongXe = request.getParameter("dongXe");
            String doiXeStr = request.getParameter("doiXe");
            String dungTichStr = request.getParameter("dungTich");
            Part filePart = request.getPart("hinhAnh");

            String base = ctx + "/doitac/quanlymauxe?maChiNhanh=" + (maChiNhanhStr != null ? maChiNhanhStr : "");

            // Validation
            if (maChiNhanhStr == null || maChiNhanhStr.trim().isEmpty()) {
                response.sendRedirect(ctx + "/doitac/quanlymauxe?msgType=error&msg="
                        + URLEncoder.encode("Thiếu mã chi nhánh", "UTF-8"));
                return;
            }
            if (hangXe == null || hangXe.trim().isEmpty()) {
                response.sendRedirect(base + "&msgType=error&msg="
                        + URLEncoder.encode("Hãng xe không được để trống", "UTF-8"));
                return;
            }
            if (dongXe == null || dongXe.trim().isEmpty()) {
                response.sendRedirect(base + "&msgType=error&msg="
                        + URLEncoder.encode("Dòng xe không được để trống", "UTF-8"));
                return;
            }
            if (doiXeStr == null || doiXeStr.trim().isEmpty()) {
                response.sendRedirect(base + "&msgType=error&msg="
                        + URLEncoder.encode("Đời xe không được để trống", "UTF-8"));
                return;
            }
            if (dungTichStr == null || dungTichStr.trim().isEmpty()) {
                response.sendRedirect(base + "&msgType=error&msg="
                        + URLEncoder.encode("Dung tích không được để trống", "UTF-8"));
                return;
            }

            try {
                int maChiNhanh = Integer.parseInt(maChiNhanhStr.trim());
                int doiXe = Integer.parseInt(doiXeStr.trim());
                float dungTich = Float.parseFloat(dungTichStr.trim());

                if (doiXe < 1900 || doiXe > 2100) {
                    response.sendRedirect(base + "&msgType=error&msg="
                            + URLEncoder.encode("Đời xe không hợp lệ (1900–2100)", "UTF-8"));
                    return;
                }
                if (dungTich <= 0) {
                    response.sendRedirect(base + "&msgType=error&msg="
                            + URLEncoder.encode("Dung tích phải lớn hơn 0", "UTF-8"));
                    return;
                }

                // Create and insert MauXe
                MauXe mx = new MauXe();
                mx.setMaDoiTac(maDoiTac);
                mx.setMaChiNhanh(maChiNhanh);
                mx.setHangXe(hangXe.trim());
                mx.setDongXe(dongXe.trim());
                mx.setDoiXe(doiXe);
                mx.setDungTich(dungTich);
                mx.setUrlHinhAnh("");

                new MauXeDAO().themMauXe(mx);

                // Get the newly inserted record
                List<MauXe> allModels = new MauXeDAO().layDanhSachMauXeTheoChiNhanh(maChiNhanh, maDoiTac);
                if (!allModels.isEmpty()) {
                    MauXe lastModel = allModels.get(allModels.size() - 1);
                    int maMauXe = lastModel.getMaMauXe();
                    String imageFileName = "";

                    // Handle file upload if present
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = extractFileName(filePart);
                        if (fileName != null && !fileName.isEmpty()) {
                            System.out.println("[MauXeUploadServlet] File selected: " + fileName + ", Size: " + filePart.getSize());
                            
                            // Validate file size
                            if (filePart.getSize() > 5 * 1024 * 1024) {
                                response.sendRedirect(base + "&msgType=error&msg="
                                        + URLEncoder.encode("Kích thước file không được vượt quá 5MB", "UTF-8"));
                                return;
                            }

                            // Validate file type
                            String contentType = filePart.getContentType();
                            if (contentType == null || !contentType.startsWith("image/")) {
                                System.out.println("[MauXeUploadServlet] Invalid content type: " + contentType);
                                response.sendRedirect(base + "&msgType=error&msg="
                                        + URLEncoder.encode("Vui lòng chọn file ảnh", "UTF-8"));
                                return;
                            }

                            String ext = fileName.substring(fileName.lastIndexOf("."));
                            imageFileName = maMauXe + ext;

                            // Create upload directory - with fallback logic
                            String uploadDirPath = getServletContext().getRealPath("/public/img/mauXe");
                            
                            // Fallback: if getRealPath returns null, construct path from catalina base
                            if (uploadDirPath == null) {
                                String catalinaBase = System.getProperty("catalina.base");
                                if (catalinaBase != null) {
                                    uploadDirPath = catalinaBase + File.separator + "webapps" + File.separator + "thuexemay" + File.separator + "public" + File.separator + "img" + File.separator + "mauXe";
                                } else {
                                    // Final fallback: use webapp root
                                    String webappRoot = getServletContext().getRealPath("/");
                                    if (webappRoot != null) {
                                        uploadDirPath = webappRoot + "public" + File.separator + "img" + File.separator + "mauXe";
                                    } else {
                                        throw new IOException("Cannot determine upload directory path");
                                    }
                                }
                            }
                            
                            File uploadDir = new File(uploadDirPath);
                            System.out.println("[MauXeUploadServlet] Catalina Base: " + System.getProperty("catalina.base"));
                            System.out.println("[MauXeUploadServlet] Upload directory: " + uploadDirPath);
                            System.out.println("[MauXeUploadServlet] Directory exists: " + uploadDir.exists());
                            System.out.println("[MauXeUploadServlet] Canwrite: " + uploadDir.canWrite());
                            
                            if (!uploadDir.exists()) {
                                boolean created = uploadDir.mkdirs();
                                System.out.println("[MauXeUploadServlet] Created directory: " + created);
                                if (created) {
                                    System.out.println("[MauXeUploadServlet] Directory now exists: " + uploadDir.exists());
                                    System.out.println("[MauXeUploadServlet] Can write: " + uploadDir.canWrite());
                                }
                            }

                            // Save file using InputStream
                            File uploadFile = new File(uploadDir, imageFileName);
                            System.out.println("[MauXeUploadServlet] Saving to: " + uploadFile.getAbsolutePath());
                            System.out.println("[MauXeUploadServlet] Parent can write: " + uploadFile.getParentFile().canWrite());
                            
                            try (InputStream fis = filePart.getInputStream();
                                 FileOutputStream fos = new FileOutputStream(uploadFile)) {
                                byte[] buffer = new byte[1024];
                                int len;
                                int totalBytes = 0;
                                while ((len = fis.read(buffer)) != -1) {
                                    fos.write(buffer, 0, len);
                                    totalBytes += len;
                                }
                                fos.flush();
                                System.out.println("[MauXeUploadServlet] Total bytes written: " + totalBytes);
                            } catch (IOException ioEx) {
                                System.out.println("[MauXeUploadServlet] Error writing file: " + ioEx.getMessage());
                                ioEx.printStackTrace();
                                response.sendRedirect(base + "&msgType=error&msg="
                                        + URLEncoder.encode("Lỗi khi lưu file: " + ioEx.getMessage(), "UTF-8"));
                                return;
                            }
                            
                            System.out.println("[MauXeUploadServlet] File saved successfully: " + uploadFile.getAbsolutePath());
                            System.out.println("[MauXeUploadServlet] File exists after save: " + uploadFile.exists());
                            System.out.println("[MauXeUploadServlet] File size: " + uploadFile.length());

                            // Copy file to source directory as well (for version control)
                            String sourceDir = "e:\\thuexemay\\src\\main\\webapp\\public\\img\\mauXe";
                            File sourceDirFile = new File(sourceDir);
                            if (!sourceDirFile.exists()) {
                                sourceDirFile.mkdirs();
                            }
                            File sourceFile = new File(sourceDirFile, imageFileName);
                            System.out.println("[MauXeUploadServlet] Copying to source: " + sourceFile.getAbsolutePath());
                            
                            try (InputStream sourceFis = new java.io.FileInputStream(uploadFile);
                                 FileOutputStream sourceFos = new FileOutputStream(sourceFile)) {
                                byte[] buffer = new byte[1024];
                                int len;
                                while ((len = sourceFis.read(buffer)) != -1) {
                                    sourceFos.write(buffer, 0, len);
                                }
                                sourceFos.flush();
                                System.out.println("[MauXeUploadServlet] File copied to source: " + sourceFile.getAbsolutePath());
                                System.out.println("[MauXeUploadServlet] Source file exists: " + sourceFile.exists());
                            } catch (IOException copyEx) {
                                System.out.println("[MauXeUploadServlet] Warning - Could not copy to source: " + copyEx.getMessage());
                                // Don't fail here - file is already in deployment
                            }

                            // Update database with image path
                            String imagePath = "/public/img/mauXe/" + imageFileName;
                            lastModel.setUrlHinhAnh(imagePath);
                            new MauXeDAO().capNhatMauXe(lastModel);
                            System.out.println("[MauXeUploadServlet] Database updated with path: " + imagePath);

                            response.sendRedirect(base + "&msgType=success&msg="
                                    + URLEncoder.encode("Thêm mẫu xe và upload hình ảnh thành công!", "UTF-8"));
                        }
                    }

                    // No file uploaded - just success message
                    if (imageFileName.isEmpty()) {
                        System.out.println("[MauXeUploadServlet] No image file uploaded");
                        response.sendRedirect(base + "&msgType=success&msg="
                                + URLEncoder.encode("Thêm mẫu xe thành công! (Không upload hình ảnh)", "UTF-8"));
                    }
                }

            } catch (NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(base + "&msgType=error&msg="
                        + URLEncoder.encode("Định dạng số liệu không hợp lệ", "UTF-8"));
                return;
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
                response.sendRedirect(base + "&msgType=error&msg="
                        + URLEncoder.encode(e.getMessage(), "UTF-8"));
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[MauXeUploadServlet] Exception: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/doitac/quanlymauxe?msgType=error&msg="
                    + URLEncoder.encode("Lỗi hệ thống: " + e.getMessage(), "UTF-8"));
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return null;
    }
}
