-- Migration: Drop thoiGianThanhToan column from ThanhToan table
-- Reason: Consolidating payment timestamp into single thoiGianTao column
-- Date: 2026-04-12
-- This script removes the redundant thoiGianThanhToan column

-- Only run this if you previously applied migration_add_thoiGianThanhToan.sql
-- Otherwise, use db.sql as the base schema

ALTER TABLE ThanhToan DROP COLUMN thoiGianThanhToan;

-- Verify the change
DESCRIBE ThanhToan;
