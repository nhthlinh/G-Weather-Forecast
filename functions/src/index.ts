// functions/src/index.ts
import * as functions from 'firebase-functions/v1';
import * as admin from 'firebase-admin';
import * as nodemailer from 'nodemailer';
import axios from 'axios';

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'your-email@gmail.com',
    pass: 'your-app-password', // hoặc dùng SendGrid
  },
});

export const sendWeatherEmails = functions.pubsub
  .schedule('every day 00:40')
  .timeZone('Asia/Ho_Chi_Minh')
  .onRun(async () => {
    const snapshot = await admin.firestore().collection('subscriptions').get();

    for (const doc of snapshot.docs) {
      const { location, verified } = doc.data();
      const email = doc.id;

      if (!verified) continue;

      const weather = await fetchWeatherFor(location);
      const htmlContent = `
        <div style="font-family: Arial, sans-serif; padding: 20px; background-color: #f9f9f9; color: #333;">
            <div style="background-color: #ffffff; padding: 24px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <h2 style="color: #007BFF;">🌤️ Dự báo thời tiết tại ${weather.location.name}, ${weather.location.country}</h2>
            
            <p style="margin: 0; font-size: 16px;">⏰ Thời gian địa phương: <strong>${weather.location.localtime}</strong></p>
            <p style="margin: 8px 0;"><img src="https:${weather.current.condition.icon}" alt="${weather.current.condition.text}" style="vertical-align: middle;"> 
                <strong>${weather.current.condition.text}</strong>
            </p>
            
            <ul style="padding-left: 18px; line-height: 1.6;">
                <li><strong>Nhiệt độ:</strong> ${weather.current.temp_c}°C (Cảm giác như ${weather.current.feelslike_c}°C)</li>
                <li><strong>Độ ẩm:</strong> ${weather.current.humidity}%</li>
                <li><strong>Gió:</strong> ${weather.current.wind_kph} km/h (${weather.current.wind_dir})</li>
                <li><strong>Áp suất:</strong> ${weather.current.pressure_mb} mb</li>
                <li><strong>Tầm nhìn:</strong> ${weather.current.vis_km} km</li>
                <li><strong>Chỉ số UV:</strong> ${weather.current.uv}</li>
            </ul>

            ${
                weather.current.air_quality
                ? `<h4 style="margin-top: 24px;">🌫️ Chất lượng không khí</h4>
                    <ul style="padding-left: 18px; line-height: 1.6;">
                    <li>PM2.5: ${weather.current.air_quality.pm2_5}</li>
                    <li>PM10: ${weather.current.air_quality.pm10}</li>
                    <li>CO: ${weather.current.air_quality.co}</li>
                    <li>NO₂: ${weather.current.air_quality.no2}</li>
                    <li>O₃: ${weather.current.air_quality.o3}</li>
                    <li>SO₂: ${weather.current.air_quality.so2}</li>
                    <li>US EPA Index: ${weather.current.air_quality['us-epa-index']}</li>
                    </ul>`
                : ''
            }

            <hr style="margin-top: 30px; border: none; border-top: 1px solid #eee;">
            <p style="font-size: 14px; color: #888;">📬 Gửi từ G-Weather – dự báo chính xác mỗi ngày.</p>
            </div>
        </div>
        `;

      await transporter.sendMail({
        from: 'G-Weather <your-email@gmail.com>',
        to: email,
        subject: `Dự báo thời tiết hôm nay tại ${location}`,
        html: htmlContent,
      });
    }

    return null;
});

const API_KEY = '99a1893ac02d44e3b4823359252205';
const BASE_URL = 'https://api.weatherapi.com/v1';

export async function fetchWeatherFor(location: string): Promise<any> {
  const url = `${BASE_URL}/current.json?q=${encodeURIComponent(location)}`;

  const response = await axios.get(url, {
    headers: {
      'key': API_KEY
    }
  });

  return response.data; // Hoặc xử lý và trả về thông tin cụ thể nếu muốn
}

