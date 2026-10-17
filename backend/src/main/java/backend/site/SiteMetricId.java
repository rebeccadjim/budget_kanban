package backend.site;

import java.io.Serializable;
import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Embeddable
public record SiteMetricId(
        @Column(name = "site_id") Long siteId,
        @Column(name = "time") Instant time
) implements Serializable { }