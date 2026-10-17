package backend.site;

import jakarta.persistence.*;

@Entity
@Table(name = "site_metric")
public class SiteMetric {

    @EmbeddedId
    private SiteMetricId id;

    @Column(name = "traffic_mbps")
    private Double trafficMbps;

    @Column(name = "prb_load_pct")
    private Double prbLoadPct;

    @Column(name = "energy_kwh")
    private Double energyKwh;

    @Column(name = "temperature_c")
    private Double temperatureC;

    protected SiteMetric() { }

    public SiteMetric(SiteMetricId id, Double trafficMbps, Double prbLoadPct,
                      Double energyKwh, Double temperatureC) {
        this.id = id;
        this.trafficMbps = trafficMbps;
        this.prbLoadPct = prbLoadPct;
        this.energyKwh = energyKwh;
        this.temperatureC = temperatureC;
    }

    public SiteMetricId getId() { return id; }
    public Double getTrafficMbps() { return trafficMbps; }
    public Double getPrbLoadPct() { return prbLoadPct; }
    public Double getEnergyKwh() { return energyKwh; }
    public Double getTemperatureC() { return temperatureC; }
}