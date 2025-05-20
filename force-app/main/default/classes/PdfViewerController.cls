public with sharing class PdfViewerController {
    @AuraEnabled(cacheable=true)
    public static String getPdfContent(String recordId) {
        try {
            System.debug('PdfViewerController: Using recordId: ' + recordId);
            
            // Get ContentDocumentLinks related to the record
            List<ContentDocumentLink> contentDocLinks = [
                SELECT ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId = :recordId
                ORDER BY ContentDocument.CreatedDate DESC
            ];
            
            if (contentDocLinks.isEmpty()) {
                System.debug('PdfViewerController: No content documents found for record');
                throw new AuraHandledException('No files found for this record');
            }
            
            // Iterate through documents to find the first PDF
            for (ContentDocumentLink cdl : contentDocLinks) {
                // Get ContentVersion for the document
                List<ContentVersion> cvList = [
                    SELECT VersionData, FileType, Title 
                    FROM ContentVersion 
                    WHERE ContentDocumentId = :cdl.ContentDocumentId 
                    AND IsLatest = true
                    LIMIT 1
                ];
                
                if (!cvList.isEmpty()) {
                    ContentVersion cv = cvList[0];
                    
                    // Check if it's a PDF
                    if (cv.FileType.equalsIgnoreCase('PDF')) {
                        System.debug('PdfViewerController: Found PDF: ' + cv.Title);
                        String encoded = EncodingUtil.base64Encode(cv.VersionData);
                        System.debug('PdfViewerController: Encoded PDF length: ' + encoded.length());
                        return encoded;
                    }
                }
            }
            
            // If we get here, no PDFs were found
            throw new AuraHandledException('No PDF files found for this record');
            
        } catch (Exception e) {
            System.debug('PdfViewerController: Exception: ' + e.getMessage());
            throw new AuraHandledException('Error retrieving PDF: ' + e.getMessage());
        }
    }
}