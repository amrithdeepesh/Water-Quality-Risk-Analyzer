package com.waterquality.service;

import java.util.ArrayList;
import java.util.List;

import com.waterquality.model.ParameterAssessment;
import com.waterquality.model.WaterAnalysisResult;
import com.waterquality.model.WaterSample;

public final class WaterQualityAnalyzer implements WaterAnalysisOperations {
    private static final int SCORED_PARAMETERS = 7;

    @Override
    public WaterAnalysisResult analyze(WaterSample sample) {
        List<ParameterAssessment> items =
                new ArrayList<ParameterAssessment>();
        addPh(items, sample.getPh());
        addTurbidity(items, sample.getTurbidity());
        addTds(items, sample.getTds());
        addDissolvedOxygen(items, sample.getDissolvedOxygen());
        addTemperature(items, sample.getTemperature());
        addHardness(items, sample.getHardness());
        addChlorine(items, sample.getFreeChlorine());
        addColiform(items, sample.isColiformDetected());
        int totalSeverity = 0;
        for (ParameterAssessment item : items) {
            totalSeverity += item.getSeverity();
        }
        int score = (int) Math.round(totalSeverity * 100.0
                / (SCORED_PARAMETERS * 3));
        String level = score < 10 ? "Safe"
                : score < 30 ? "Moderate"
                : score < 60 ? "High" : "Critical";
        return new WaterAnalysisResult(sample, items, score, level);
    }

    private void addPh(List<ParameterAssessment> items, double value) {
        add(items, "pH", format(value), value >= 6.5 && value <= 8.5 ? 0
                : value >= 6.0 && value <= 9.0 ? 1
                : value >= 5.0 && value <= 10.0 ? 2 : 3,
                "Check pH and use an appropriate treatment before drinking.");
    }

    private void addTurbidity(List<ParameterAssessment> items, double value) {
        add(items, "Turbidity", format(value) + " NTU",
                value <= 1 ? 0 : value <= 5 ? 1 : value <= 10 ? 2 : 3,
                "Reduce suspended particles and retest the clarified sample.");
    }

    private void addTds(List<ParameterAssessment> items, double value) {
        add(items, "TDS", format(value) + " mg/L",
                value <= 500 ? 0 : value <= 2000 ? 1
                : value <= 3000 ? 2 : 3,
                "Investigate dissolved solids and retest after treatment.");
    }

    private void addDissolvedOxygen(List<ParameterAssessment> items,
            double value) {
        add(items, "Dissolved oxygen", format(value) + " mg/L",
                value >= 5 ? 0 : value >= 3 ? 1 : value >= 1 ? 2 : 3,
                "Low dissolved oxygen can indicate water-quality stress; investigate the source.");
    }
    private void addTemperature(List<ParameterAssessment> items,
            double value) {
        items.add(new ParameterAssessment("Temperature",
                format(value) + " °C", "Information",
                "Recorded for context; temperature is not scored as a drinking-water limit.",
                0));
    }

    private void addHardness(List<ParameterAssessment> items, double value) {
        add(items, "Total hardness", format(value) + " mg/L as CaCO3",
                value <= 200 ? 0 : value <= 600 ? 1
                : value <= 1200 ? 2 : 3,
                "Investigate hardness and consider suitable treatment.");
    }

    private void addChlorine(List<ParameterAssessment> items, double value) {
        int severity = value >= 0.2 && value <= 0.5 ? 0
                : value >= 0.1 && value <= 1.0 ? 1
                : value <= 2.0 ? 2 : 3;
        add(items, "Free residual chlorine", format(value) + " mg/L",
                severity,
                "Check disinfection and residual chlorine at the sample point.");
    }

    private void addColiform(List<ParameterAssessment> items,
            boolean detected) {
        add(items, "Coliform indicator", detected ? "Detected" : "Not detected",
                detected ? 3 : 0,
                "A detected indicator requires prompt laboratory confirmation and professional guidance.");
    }

    private void add(List<ParameterAssessment> items, String name,
            String value, int severity, String advice) {
        String[] labels = { "Safe", "Moderate", "High", "Critical" };
        String recommendation = severity == 0
                ? "Within the project's demo reference range." : advice;
        items.add(new ParameterAssessment(name, value, labels[severity],
                recommendation, severity));
    }

    private String format(double value) {
        if (value == Math.rint(value)) {
            return String.valueOf((long) value);
        }
        return String.format(java.util.Locale.ROOT, "%.2f", value);
    }
}
