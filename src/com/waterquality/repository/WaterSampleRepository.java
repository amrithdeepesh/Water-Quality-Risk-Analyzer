package com.waterquality.repository;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.waterquality.config.Database;
import com.waterquality.exception.RepositoryException;
import com.waterquality.model.WaterAnalysisResult;
import com.waterquality.model.WaterSample;

/** Stores analyses and returns only demo or explicitly shared records for the map. */
public final class WaterSampleRepository {
    private WaterSampleRepository() { }

    public static void save(String username, WaterAnalysisResult analysis,
            boolean includeOnMap) {
        WaterSample sample = analysis.getSample();
        String sql = "INSERT INTO water_samples "
                + "(submitted_by,state,city,water_source,collection_date,latitude,longitude,"
                + "ph,turbidity,tds,dissolved_oxygen,temperature,hardness,free_chlorine,"
                + "coliform_detected,risk_score,risk_level,is_demo,include_on_map,data_source) "
                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,FALSE,?,?)";
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, sample.getState());
            statement.setString(3, sample.getCity());
            statement.setString(4, sample.getWaterSource());
            statement.setDate(5, Date.valueOf(sample.getCollectionDate()));
            statement.setDouble(6, sample.getLatitude());
            statement.setDouble(7, sample.getLongitude());
            statement.setDouble(8, sample.getPh());
            statement.setDouble(9, sample.getTurbidity());
            statement.setDouble(10, sample.getTds());
            statement.setDouble(11, sample.getDissolvedOxygen());
            statement.setDouble(12, sample.getTemperature());
            statement.setDouble(13, sample.getHardness());
            statement.setDouble(14, sample.getFreeChlorine());
            statement.setBoolean(15, sample.isColiformDetected());
            statement.setInt(16, analysis.getRiskScore());
            statement.setString(17, analysis.getRiskLevel());
            statement.setBoolean(18, includeOnMap);
            statement.setString(19, includeOnMap
                    ? "User shared anonymously" : "Private user submission");
            statement.executeUpdate();
        } catch (SQLException exception) {
            throw new RepositoryException("Could not save this sample to MySQL.", exception);
        }
    }

    public static String listPublicMapSamples() {
        String sql = "SELECT id,city,state,water_source,collection_date,latitude,longitude,"
                + "risk_score,risk_level,is_demo,data_source FROM water_samples "
                + "WHERE is_demo = TRUE OR include_on_map = TRUE "
                + "ORDER BY collection_date DESC LIMIT 1000";
        StringBuilder json = new StringBuilder("{\"source\":\"mysql\",\"samples\":[");
        try (Connection connection = Database.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet rows = statement.executeQuery()) {
            boolean first = true;
            while (rows.next()) {
                if (!first) json.append(',');
                first = false;
                json.append('{')
                    .append("\"id\":").append(rows.getLong("id")).append(',')
                    .append("\"city\":").append(quote(rows.getString("city"))).append(',')
                    .append("\"state\":").append(quote(rows.getString("state"))).append(',')
                    .append("\"source\":").append(quote(rows.getString("water_source"))).append(',')
                    .append("\"date\":").append(quote(rows.getString("collection_date"))).append(',')
                    .append("\"lat\":").append(rows.getBigDecimal("latitude")).append(',')
                    .append("\"lng\":").append(rows.getBigDecimal("longitude")).append(',')
                    .append("\"score\":").append(rows.getInt("risk_score")).append(',')
                    .append("\"risk\":").append(quote(rows.getString("risk_level").toLowerCase(java.util.Locale.ROOT))).append(',')
                    .append("\"demo\":").append(rows.getBoolean("is_demo")).append(',')
                    .append("\"dataSource\":").append(quote(rows.getString("data_source")))
                    .append('}');
            }
            return json.append("]}").toString();
        } catch (SQLException exception) {
            throw new RepositoryException("Could not load map samples from MySQL.", exception);
        }
    }

    private static String quote(String value) {
        if (value == null) return "null";
        StringBuilder escaped = new StringBuilder("\"");
        for (int index = 0; index < value.length(); index++) {
            char ch = value.charAt(index);
            if (ch == '"' || ch == '\\') escaped.append('\\');
            if (ch == '\n') escaped.append("\\n");
            else if (ch == '\r') escaped.append("\\r");
            else escaped.append(ch);
        }
        return escaped.append('"').toString();
    }
}
