package com.example.currencyguru;

// ...
import android.content.ContentValues;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.google.cloud.vision.v1.AnnotateImageRequest;
import com.google.cloud.vision.v1.AnnotateImageResponse;
import com.google.cloud.vision.v1.BatchAnnotateImagesResponse;
import com.google.cloud.vision.v1.Feature;
import com.google.cloud.vision.v1.Image;
import com.google.cloud.vision.v1.ImageAnnotatorClient;
import com.google.protobuf.ByteString;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Arrays;
import java.util.List;
// ...

public class MainActivity extends AppCompatActivity {

    // ...
    private static final int CAMERA_REQUEST = 1888;
    private ImageView imageView;
    private TextView textView;
    private Button captureButton;
    private String apiKey; // Load your Google Cloud API key securely

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        imageView = findViewById(R.id.imageView);
        textView = findViewById(R.id.textView);
        captureButton = findViewById(R.id.captureButton);

        captureButton.setOnClickListener(view -> {
            Intent cameraIntent = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
            startActivityForResult(cameraIntent, CAMERA_REQUEST);
        });
    }

    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == CAMERA_REQUEST && resultCode == RESULT_OK) {
            Bitmap photo = (Bitmap) data.getExtras().get("data");
            imageView.setImageBitmap(photo);

            // Save the captured image
            Uri imageUri = saveImageToStorage(photo);

            // Detect the currency
            if (imageUri != null) {
                detectCurrency(imageUri);
            }
        }
    }

    private Uri saveImageToStorage(Bitmap image) {
        String imageName = "currency_" + System.currentTimeMillis() + ".jpg";
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.TITLE, imageName);
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg");

        Uri uri = getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        try (OutputStream outputStream = getContentResolver().openOutputStream(uri)) {
            image.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);
            return uri;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void detectCurrency(Uri imageUri) {
        new AsyncTask<Void, Void, String>() {
            @Override
            protected String doInBackground(Void... voids) {
                try {
                    Bitmap bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), imageUri);
                    ByteArrayOutputStream stream = new ByteArrayOutputStream();
                    bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);
                    byte[] byteArray = stream.toByteArray();
                    ByteString byteString = ByteString.copyFrom(byteArray);

                    Image image = Image.newBuilder().setContent(byteString).build();
                    Feature feature = Feature.newBuilder().setType(Feature.Type.TEXT_DETECTION).build();
                    AnnotateImageRequest request = AnnotateImageRequest.newBuilder().addFeatures(feature).setImage(image).build();
                    List<AnnotateImageRequest> requests = Arrays.asList(request);

                    try (ImageAnnotatorClient client = ImageAnnotatorClient.create()) {
                        BatchAnnotateImagesResponse response = client.batchAnnotateImages(requests);
                        List<AnnotateImageResponse> responses = response.getResponsesList();
                        if (!responses.isEmpty()) {
                            return responses.get(0).getFullTextAnnotation().getText();
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return null;
            }

            @Override
            protected void onPostExecute(String result) {
                if (result != null) {
                    // Parse the detected currency and display it
                    String currency = parseCurrency(result);
                    textView.setText(currency != null ? "Detected Currency: " + currency : "No currency detected");
                } else {
                    textView.setText("No currency detected");
                }
            }
        }.execute();
    }

    private String parseCurrency(String result) {
        // Add your own logic to parse the detected currency from the text
        // Example: Look for currency symbols like $, €, £ or currency codes like USD, EUR, GBP
        // Return the detected currency as a String or null if not found
        return result;
    }
}

