package cache;

import java.util.concurrent.ConcurrentHashMap;
import model.DonThue;

/**
 * Temporary payment cache for cross-device QR code validation
 * Stores pending payments keyed by maThanhToan (temp ID)
 * Each entry expires after 3 minutes
 * Tracks completed payments for cross-device redirect
 */
public class PaymentCache {

	private static class PaymentInfo {
		double soTien;
		String phuongThuc;
		long thoiGianTao;
		boolean completed;
		DonThue donThueAo; // Store rental order for cross-device access

		PaymentInfo(double soTien, String phuongThuc, long thoiGianTao, DonThue donThueAo) {
			this.soTien = soTien;
			this.phuongThuc = phuongThuc;
			this.thoiGianTao = thoiGianTao;
			this.completed = false;
			this.donThueAo = donThueAo;
		}
	}

	private static final ConcurrentHashMap<Integer, PaymentInfo> cache = new ConcurrentHashMap<>();
	private static final long TIMEOUT = 180000; // 3 minutes in milliseconds

	/**
	 * Store payment info in cache with rental order
	 */
	public static void put(int maThanhToan, double soTien, String phuongThuc, DonThue donThueAo) {
		long now = System.currentTimeMillis();
		cache.put(maThanhToan, new PaymentInfo(soTien, phuongThuc, now, donThueAo));
		System.out.println("DEBUG: Stored in cache - maThanhToan=" + maThanhToan + ", soTien=" + soTien);
	}

	/**
	 * Retrieve payment info from cache
	 * Returns null if expired or not found
	 */
	public static PaymentInfo get(int maThanhToan) {
		PaymentInfo info = cache.get(maThanhToan);
		if (info == null) {
			System.out.println("DEBUG: Not found in cache - maThanhToan=" + maThanhToan);
			return null;
		}

		// Check if expired
		long elapsed = System.currentTimeMillis() - info.thoiGianTao;
		if (elapsed > TIMEOUT) {
			System.out.println("DEBUG: Expired in cache - maThanhToan=" + maThanhToan + ", elapsed=" + elapsed);
			cache.remove(maThanhToan);
			return null;
		}

		return info;
	}

	/**
	 * Get amount
	 */
	public static double getSoTien(int maThanhToan) {
		PaymentInfo info = get(maThanhToan);
		return info != null ? info.soTien : -1;
	}

	/**
	 * Get payment method
	 */
	public static String getPhuongThuc(int maThanhToan) {
		PaymentInfo info = get(maThanhToan);
		return info != null ? info.phuongThuc : null;
	}

	/**
	 * Get rental order
	 */
	public static DonThue getDonThueAo(int maThanhToan) {
		PaymentInfo info = get(maThanhToan);
		return info != null ? info.donThueAo : null;
	}

	/**
	 * Get creation time
	 */
	public static long getThoiGianTao(int maThanhToan) {
		PaymentInfo info = get(maThanhToan);
		return info != null ? info.thoiGianTao : -1;
	}

	/**
	 * Mark payment as completed
	 */
	public static void markCompleted(int maThanhToan) {
		PaymentInfo info = cache.get(maThanhToan);
		if (info != null) {
			info.completed = true;
			System.out.println("DEBUG: Marked completed - maThanhToan=" + maThanhToan);
		}
	}

	/**
	 * Check if payment is completed
	 */
	public static boolean isCompleted(int maThanhToan) {
		PaymentInfo info = get(maThanhToan);
		return info != null && info.completed;
	}

	/**
	 * Remove payment from cache
	 */
	public static void remove(int maThanhToan) {
		cache.remove(maThanhToan);
	}

	/**
	 * Check if exists and not expired
	 */
	public static boolean exists(int maThanhToan) {
		return get(maThanhToan) != null;
	}
}
