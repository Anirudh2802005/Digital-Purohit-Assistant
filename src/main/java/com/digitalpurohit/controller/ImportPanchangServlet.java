package com.digitalpurohit.controller;

import java.io.File;
import java.io.IOException;

import com.digitalpurohit.service.PanchangImportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/import-panchang")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 20 * 1024 * 1024,       // 20 MB
        maxRequestSize = 25 * 1024 * 1024     // 25 MB
)
public class ImportPanchangServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PanchangImportService importService;

    @Override
    public void init() throws ServletException {

        importService = new PanchangImportService();

    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/panchang/import-panchang.jsp")
                .forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        Part part = request.getPart("excelFile");

        /* -----------------------------------------
           Validate File Selection
        ------------------------------------------ */

        if (part == null || part.getSize() == 0) {

            request.setAttribute("error",
                    "Please choose an Excel file.");

            doGet(request, response);
            return;

        }

        /* -----------------------------------------
           Validate File Type
        ------------------------------------------ */

        String fileName = part.getSubmittedFileName();

        if (fileName == null ||
                !(fileName.toLowerCase().endsWith(".xlsx")
                || fileName.toLowerCase().endsWith(".xls"))) {

            request.setAttribute("error",
                    "Only Excel (.xlsx or .xls) files are allowed.");

            doGet(request, response);
            return;

        }

        File tempFile = null;

        try {

            /* -----------------------------------------
               Save Uploaded File
            ------------------------------------------ */

            tempFile = File.createTempFile("panchang_", ".xlsx");

            part.write(tempFile.getAbsolutePath());

            /* -----------------------------------------
               Import Excel
            ------------------------------------------ */

            int importedRecords =
                    importService.importPanchang(tempFile);

            request.setAttribute(
                    "success",
                    importedRecords +
                    " Panchang records imported successfully."
            );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Failed to import Panchang Excel file."
            );

        } finally {

            /* -----------------------------------------
               Delete Temporary File
            ------------------------------------------ */

            if (tempFile != null && tempFile.exists()) {

                tempFile.delete();

            }

        }

        doGet(request, response);

    }

}