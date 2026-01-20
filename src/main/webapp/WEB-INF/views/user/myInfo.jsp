<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 정보 - VROOM</title>
    <style>
        :root {
            --color-primary: #6B8E23;
            --color-secondary: #F2CB05;
            --color-tertiary: #F2B807;
            --color-accent: #F2A007;
            --color-warm: #D97218;
            --color-dark: #2C3E50;
            --color-gray: #7F8C8D;
            --color-light-gray: #ECF0F1;
            --color-white: #FFFFFF;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont,
            'Segoe UI', 'Malgun Gothic', sans-serif;
            background-color: #FAFAFA;
            color: var(--color-dark);
            line-height: 1.6;
        }

        /* Header reused from main */
        .header {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.12);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo h1 {
            color: var(--color-white);
            font-size: 1.5rem;
            font-weight: 700;
            cursor: pointer;
        }

        .nav-menu {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .nav-item {
            color: var(--color-white);
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        .nav-login,
        .nav-signup {
            background-color: rgba(255, 255, 255, 0.15);
        }

        .nav-user {
            background-color: var(--color-white);
            color: var(--color-primary);
            font-weight: 600;
            border: 2px solid var(--color-white);
            cursor: pointer;
        }

        /* Dropdown Styles */
        .nav-dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-menu {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background-color: var(--color-white);
            min-width: 160px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1001;
            border-radius: 8px;
            overflow: hidden;
            margin-top: 0.5rem;
            animation: fadeIn 0.2s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-menu.active {
            display: block;
        }

        .dropdown-item {
            color: var(--color-dark);
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: 0.9rem;
            transition: background-color 0.2s;
        }

        .dropdown-item:hover {
            background-color: #f1f1f1;
            color: var(--color-primary);
        }

        .dropdown-divider {
            height: 1px;
            background-color: var(--color-light-gray);
            margin: 4px 0;
        }

        .dropdown-item.logout {
            color: #e74c3c;
        }

        .dropdown-item.logout:hover {
            background-color: #fdeaea;
        }

        /* Dashboard Layout */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        .dashboard-container {
            display: flex;
            gap: 2rem;
            padding: 3rem 0;
            min-height: 80vh;
        }

        /* Sidebar */
        .sidebar {
            width: 250px;
            flex-shrink: 0;
        }

        .sidebar-menu {
            list-style: none;
            background-color: var(--color-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
            /* Enhanced shadow */
        }

        .sidebar-item {
            border-bottom: 1px solid var(--color-light-gray);
        }

        .sidebar-item:last-child {
            border-bottom: none;
        }

        .sidebar-link {
            display: block;
            padding: 1.25rem 1.5rem;
            text-decoration: none;
            color: var(--color-dark);
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .sidebar-link:hover {
            background-color: #f8f9fa;
            color: var(--color-primary);
            padding-left: 1.75rem;
        }

        .sidebar-link.active {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            font-weight: 700;
        }

        /* Main Content */
        .main-content {
            flex-grow: 1;
        }

        /* Profile Section */
        .profile-header {
            display: flex;
            align-items: center;
            gap: 2rem;
            background-color: var(--color-white);
            padding: 2.5rem;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 3rem;
            position: relative;
            border: 1px solid var(--color-light-gray);
        }

        .profile-image {
            margin-left: 8px;
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            font-weight: 700;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .profile-image:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
        }

        .profile-info {
            flex-grow: 1;
        }

        .profile-nickname {
            font-size: 2.25rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            color: var(--color-dark);
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .profile-nickname:hover {
            color: var(--color-primary);
        }

        .profile-temperature {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-top: 1.5rem;
            background-color: #FAFAFA;
            padding: 1rem;
            border-radius: 12px;
            border: 1px solid var(--color-light-gray);
        }

        .temp-label {
            font-weight: 700;
            color: var(--color-dark);
        }

        .temp-bar-container {
            flex-grow: 1;
            height: 12px;
            background-color: #E0E0E0;
            border-radius: 6px;
            overflow: hidden;
            max-width: 300px;
        }

        .temp-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #FF6B6B 0%, var(--color-warm) 100%);
            width: 36.5%;
            /* Example value */
            border-radius: 6px;
        }

        .temp-value-text {
            font-weight: 800;
            color: var(--color-warm);
            font-size: 1.1rem;
        }

        .profile-actions {
            display: flex;
            gap: 0.75rem;
            position: absolute;
            top: 2.5rem;
            right: 2.5rem;
        }

        .action-btn {
            background-color: var(--color-white);
            color: var(--color-dark);
            padding: 0.6rem 1.2rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            border: 1px solid var(--color-light-gray);
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .action-btn:hover {
            border-color: var(--color-secondary);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Tabs */
        .tabs-container {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 2rem;
            border-bottom: 1px solid var(--color-light-gray);
            padding-bottom: 1rem;
        }

        .tab-btn {
            padding: 0.75rem 1.5rem;
            background-color: var(--color-white);
            color: var(--color-dark);
            text-align: center;
            cursor: pointer;
            font-weight: 600;
            border-radius: 24px;
            border: 1px solid var(--color-light-gray);
            font-size: 0.95rem;
            transition: all 0.3s ease;
        }

        .tab-btn:hover {
            background-color: #F8F9FA;
            border-color: var(--color-secondary);
        }

        .tab-btn.active {
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            color: var(--color-dark);
            border: none;
            box-shadow: 0 4px 8px rgba(242, 203, 5, 0.2);
        }

        .write-btn-container {
            text-align: right;
            margin-bottom: 2rem;
        }

        .write-btn {
            display: inline-block;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            padding: 0.75rem 2rem;
            font-weight: 700;
            border-radius: 8px;
            cursor: pointer;
            border: none;
            box-shadow: 0 4px 8px rgba(107, 142, 35, 0.25);
            transition: all 0.3s ease;
        }

        .write-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(107, 142, 35, 0.3);
        }

        /* Activity Grid - Task Cards */
        .activity-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 4rem;
        }

        /* Task Card Styles reused from Errands List */
        .task-card {
            background-color: var(--color-white);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border: 2px solid transparent;
            cursor: pointer;
        }

        .task-card:hover {
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            transform: translateY(-4px);
            border-color: var(--color-secondary);
        }

        .task-image {
            width: 100%;
            height: 180px;
            background: linear-gradient(135deg, var(--color-light-gray) 0%, var(--color-white) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            position: relative;
        }

        .task-card-content {
            padding: 1.25rem;
        }

        .task-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.75rem;
        }

        .task-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .task-time {
            color: var(--color-gray);
            font-size: 0.8rem;
        }

        .task-card-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            line-clamp: 2;
            -webkit-box-orient: vertical;
            line-height: 1.4;
        }

        .task-author-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
        }

        .author-avatar {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.75rem;
        }

        .author-name {
            font-size: 0.85rem;
            color: var(--color-gray);
        }

        .meta-views {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.85rem;
            color: var(--color-gray);
        }

        .task-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 0.75rem;
            border-top: 1px solid var(--color-light-gray);
        }

        .task-location {
            color: var(--color-gray);
            font-size: 0.85rem;
        }

        .task-price {
            color: var(--color-accent);
            font-weight: 700;
            font-size: 1.125rem;
        }

        /* Withdrawal Section */
        .withdrawal-section {
            margin-top: 4rem;
            border-top: 1px solid var(--color-light-gray);
            padding-top: 3rem;
        }

        .withdrawal-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .withdrawal-box {
            background-color: #F8F9FA;
            padding: 2rem;
            width: 100%;
            max-width: 500px;
            font-weight: 500;
            margin-bottom: 1.5rem;
            border-radius: 12px;
            border: 1px solid var(--color-light-gray);
            color: var(--color-gray);
            font-family: monospace;
            line-height: 1.8;
        }

        .withdrawal-btn-container {
            display: flex;
            justify-content: flex-end;
        }

        .withdrawal-btn {
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            padding: 0.75rem 2rem;
            border: none;
            font-weight: 600;
            cursor: pointer;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .withdrawal-btn:hover {
            background-color: #e74c3c;
            color: white;
        }

        /* Footer reused */
        .footer {
            background-color: var(--color-dark);
            color: var(--color-white);
            padding: 3rem 0 1rem;
            margin-top: 3rem;
        }

        .footer-content {
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .footer-links {
            display: flex;
            gap: 1.5rem;
            flex-wrap: wrap;
        }

        .footer-links a {
            color: var(--color-light-gray);
            font-size: 0.9rem;
            text-decoration: none;
        }

        .footer-copyright {
            text-align: center;
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: var(--color-gray);
            font-size: 0.85rem;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 2000;
            animation: fadeIn 0.3s ease;
        }

        .modal-overlay.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-container {
            background-color: var(--color-white);
            border-radius: 16px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--color-light-gray);
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--color-dark);
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: var(--color-gray);
            cursor: pointer;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s ease;
        }

        .modal-close:hover {
            background-color: var(--color-light-gray);
            color: var(--color-dark);
        }

        .modal-tabs {
            display: flex;
            border-bottom: 1px solid var(--color-light-gray);
        }

        .modal-tab {
            flex: 1;
            padding: 1rem;
            background: none;
            border: none;
            font-size: 1rem;
            font-weight: 600;
            color: var(--color-gray);
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
        }

        .modal-tab:hover {
            background-color: #f8f9fa;
        }

        .modal-tab.active {
            color: var(--color-primary);
            border-bottom-color: var(--color-primary);
        }

        .modal-content {
            padding: 2rem;
        }

        .modal-tab-panel {
            display: none;
        }

        .modal-tab-panel.active {
            display: block;
        }

        /* Profile Image Upload */
        .profile-preview {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .preview-image {
            width: 150px;
            height: 150px;
            background: linear-gradient(135deg, var(--color-secondary) 0%, var(--color-accent) 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: white;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        .preview-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .upload-options {
            display: flex;
            gap: 1rem;
        }

        .upload-btn {
            padding: 0.75rem 1.5rem;
            background-color: var(--color-white);
            color: var(--color-primary);
            border: 2px solid var(--color-primary);
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .upload-btn:hover {
            background-color: var(--color-primary);
            color: var(--color-white);
        }

        .remove-btn {
            padding: 0.75rem 1.5rem;
            background-color: var(--color-light-gray);
            color: var(--color-gray);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .remove-btn:hover {
            background-color: #e74c3c;
            color: white;
        }

        #imageUpload {
            display: none;
        }

        /* Nickname Form */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .form-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(107, 142, 35, 0.1);
        }

        .char-count {
            text-align: right;
            font-size: 0.85rem;
            color: var(--color-gray);
            margin-top: 0.5rem;
        }

        .form-hint {
            font-size: 0.85rem;
            color: var(--color-gray);
            margin-top: 0.5rem;
        }

        /* Modal Actions */
        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            padding: 1.5rem 2rem;
            border-top: 1px solid var(--color-light-gray);
        }

        .modal-btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .modal-btn-cancel {
            background-color: var(--color-light-gray);
            color: var(--color-gray);
        }

        .modal-btn-cancel:hover {
            background-color: #d0d3d4;
        }

        .modal-btn-save {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            box-shadow: 0 4px 8px rgba(107, 142, 35, 0.25);
        }

        .modal-btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(107, 142, 35, 0.3);
        }

        /* Withdrawal Confirmation Modal */
        .withdrawal-modal-content {
            text-align: center;
        }

        .withdrawal-warning {
            font-size: 1.125rem;
            color: var(--color-dark);
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }

        .withdrawal-warning strong {
            color: #e74c3c;
            font-weight: 700;
        }

        .password-group {
            margin: 2rem 0;
        }

        .password-input {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .password-input:focus {
            outline: none;
            border-color: #e74c3c;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }

        .withdrawal-notice {
            background-color: #fff3cd;
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid #ffc107;
            text-align: left;
            margin-bottom: 1.5rem;
        }

        .withdrawal-notice-title {
            font-weight: 700;
            color: #856404;
            margin-bottom: 0.5rem;
        }

        .withdrawal-notice-text {
            font-size: 0.9rem;
            color: #856404;
            line-height: 1.5;
        }

        /* Pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
            padding: 1rem 0;
        }

        .pagination-btn {
            padding: 0.5rem 1rem;
            background-color: var(--color-white);
            color: var(--color-dark);
            border: 1px solid var(--color-light-gray);
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            min-width: 40px;
        }

        .pagination-btn:hover:not(:disabled) {
            background-color: var(--color-light-gray);
            border-color: var(--color-primary);
        }

        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .pagination-btn.active {
            background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-secondary) 100%);
            color: var(--color-white);
            border: none;
        }

        .pagination-info {
            padding: 0.5rem 1rem;
            color: var(--color-gray);
            font-size: 0.9rem;
        }

        /* Report Button */
        .report-btn {
            background-color: #e74c3c;
            color: var(--color-white);
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-left: 8px;
        }

        .report-btn:hover {
            background-color: #c0392b;
            transform: scale(1.05);
        }

        /* Report Modal */
        .report-modal-content {
            padding: 0;
        }

        .report-form-group {
            margin-bottom: 1.5rem;
        }

        .report-label {
            display: block;
            font-weight: 600;
            color: var(--color-dark);
            margin-bottom: 0.5rem;
        }

        .report-textarea {
            width: 100%;
            min-height: 150px;
            padding: 0.875rem 1rem;
            border: 2px solid var(--color-light-gray);
            border-radius: 8px;
            font-size: 1rem;
            font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Malgun Gothic', sans-serif;
            resize: vertical;
            transition: all 0.3s ease;
        }

        .report-textarea:focus {
            outline: none;
            border-color: #e74c3c;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }

        .report-info {
            background-color: #fff3cd;
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid #ffc107;
            margin-bottom: 1.5rem;
        }

        .report-info-text {
            font-size: 0.9rem;
            color: #856404;
            line-height: 1.5;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .activity-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .profile-actions {
                position: static;
                margin-top: 1rem;
            }

            .profile-header {
                flex-direction: column;
                text-align: center;
            }

            .profile-temperature {
                justify-content: center;
            }
        }
    </style>

    <!-- 글꼴 -->
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="stylesheet" as="style"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css">
</head>

<body>
<header class="header">
    <div class="header-container">
        <div class="logo">
            <h1 onclick="location.href='main_updated_2.html'">VROOM</h1>
        </div>
        <nav class="nav-menu">
            <a href="main_updated_2.html" class="nav-item">홈</a>
            <a href="#" class="nav-item">커뮤니티</a>
            <a href="#" class="nav-item">심부름꾼 전환</a>
            <div class="nav-dropdown">
                <button class="nav-item nav-user" id="userDropdownBtn">유저</button>
                <div class="dropdown-menu" id="userDropdownMenu">
                    <a href="myInfo" class="dropdown-item">나의정보</a>
                    <a href="vroomPay" class="dropdown-item">부름페이</a>
                    <a href="myActivity" class="dropdown-item">나의 활동</a>
                    <a href="#" class="dropdown-item">설정</a>
                    <a href="#" class="dropdown-item">고객지원</a>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item logout">로그아웃</a>
                </div>
            </div>
        </nav>
    </div>
</header>

<div class="container">
    <div class="dashboard-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li class="sidebar-item"><a href="myInfo" class="sidebar-link active">나의 정보</a></li>
                <li class="sidebar-item"><a href="vroomPay" class="sidebar-link">부름 페이<br>(계좌 관리)</a></li>
                <li class="sidebar-item"><a href="myActivity" class="sidebar-link">나의 활동</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">설정</a></li>
                <li class="sidebar-item"><a href="#" class="sidebar-link">고객지원</a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-image" id="profileImage">
                    <c:choose>
                        <c:when test="${not empty profile.profileImage}">
                            <img src="${pageContext.request.contextPath}${profile.profileImage}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                        </c:when>
                        <c:otherwise>V</c:otherwise>
                    </c:choose>
                </div>
                <div class="profile-info">
                    <div class="profile-nickname" id="profileNickname">${profile.nickname}</div>
                    <div class="profile-temperature">
                        <span class="temp-label">매너온도</span>
                        <div class="temp-bar-container">
                            <div class="temp-bar-fill"></div>
                        </div>
                        <span class="temp-value-text">36.5℃</span>
                    </div>
                </div>
                <div class="profile-actions">
                    <a href="myActivity" class="action-btn">나의 활동</a>
                    <a href="vroomPay" class="action-btn">부름 페이</a>
                </div>
            </div>

            <!-- Tabs -->
            <div class="tabs-container">
                <button class="tab-btn active">전체</button>
                <button class="tab-btn">부름</button>
                <button class="tab-btn">예약</button>
                <button class="tab-btn">완료</button>
            </div>

            <div class="write-btn-container">
                <button class="write-btn">글쓰기</button>
            </div>

            <!-- Grid -->
            <div class="activity-grid" id="activityGrid">
                <!-- Javascript will populate this -->
            </div>

            <!-- Pagination -->
            <div class="pagination-container" id="paginationContainer">
                <!-- Pagination will be generated by JavaScript -->
            </div>

            <!-- Withdrawal -->
            <div class="withdrawal-btn-container">
                <button class="withdrawal-btn" id="withdrawalBtn">탈퇴하기</button>
            </div>

        </main>
    </div>
</div>

<!-- Report Modal -->
<div class="modal-overlay" id="reportModal">
    <div class="modal-container">
        <div class="modal-header">
            <h2 class="modal-title">라이더 신고하기</h2>
            <button class="modal-close" id="reportModalClose">&times;</button>
        </div>

        <div class="modal-content report-modal-content">
            <div class="report-info">
                <div class="report-info-text">
                    신고 내용은 관리자가 검토 후 처리됩니다.<br>
                    허위 신고 시 서비스 이용이 제한될 수 있습니다.
                </div>
            </div>

            <div class="report-form-group">
                <label class="report-label" for="reportReason">신고 사유</label>
                <textarea class="report-textarea" id="reportReason"
                          placeholder="신고 사유를 자세히 작성해주세요.&#10;&#10;예시:&#10;- 약속 시간을 지키지 않았습니다&#10;- 물품을 분실했습니다&#10;- 불친절한 태도로 응대했습니다"></textarea>
                <div class="char-count" style="margin-top: 0.5rem;">
                    <span id="reportCharCount">0</span> / 500
                </div>
            </div>
        </div>

        <div class="modal-actions">
            <button class="modal-btn modal-btn-cancel" id="reportCancel">취소</button>
            <button class="modal-btn modal-btn-save" id="reportSubmit"
                    style="background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);">신고하기</button>
        </div>
    </div>
</div>

<!-- Withdrawal Confirmation Modal -->
<div class="modal-overlay" id="withdrawalModal">
    <div class="modal-container">
        <div class="modal-header">
            <h2 class="modal-title">회원 탈퇴</h2>
            <button class="modal-close" id="withdrawalModalClose">&times;</button>
        </div>

        <div class="modal-content withdrawal-modal-content">
            <div class="withdrawal-notice">
                <div class="withdrawal-notice-title">⚠️ 탈퇴 전 유의사항</div>
                <div class="withdrawal-notice-text">
                    • 탈퇴 시 모든 활동 내역이 삭제됩니다<br>
                    • 부름 페이 잔액은 자동으로 환불됩니다<br>
                    • 진행 중인 부름/예약은 취소됩니다<br>
                    • 탈퇴 후 7일간 재가입이 제한됩니다
                </div>
            </div>

            <p class="withdrawal-warning">
                정말로 <strong>VROOM</strong>을 탈퇴하시겠습니까?<br>
                탈퇴를 진행하려면 비밀번호를 입력해주세요.
            </p>

            <div class="password-group">
                <input type="password" class="password-input" id="withdrawalPassword" placeholder="비밀번호를 입력하세요">
            </div>
        </div>

        <div class="modal-actions">
            <button class="modal-btn modal-btn-cancel" id="withdrawalCancel">취소</button>
            <button class="modal-btn modal-btn-save" id="withdrawalConfirm"
                    style="background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);">탈퇴하기</button>
        </div>
    </div>
</div>

<!-- Profile Edit Modal -->
<div class="modal-overlay" id="profileModal">
    <div class="modal-container">
        <div class="modal-header">
            <h2 class="modal-title">프로필 수정</h2>
            <button class="modal-close" id="modalClose">&times;</button>
        </div>

        <div class="modal-tabs">
            <button class="modal-tab active" data-tab="image">프로필 이미지</button>
            <button class="modal-tab" data-tab="nickname">닉네임 변경</button>
        </div>

        <div class="modal-content">
            <!-- Profile Image Tab -->
            <div class="modal-tab-panel active" id="imagePanel">
                <div class="profile-preview">
                    <div class="preview-image" id="previewImage">
                        <c:choose>
                            <c:when test="${not empty profile.profileImage}">
                                <img src="${pageContext.request.contextPath}${profile.profileImage}" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">
                            </c:when>
                            <c:otherwise>V</c:otherwise>
                        </c:choose>
                    </div>
                    <div class="upload-options">
                        <label for="imageUpload" class="upload-btn">이미지 업로드</label>
                        <input type="file" id="imageUpload" accept="image/*">
                        <button class="remove-btn" id="removeImage">기본 이미지로</button>
                    </div>
                </div>
                <p class="form-hint">JPG, PNG 파일만 가능합니다. 최대 5MB</p>
            </div>

            <!-- Nickname Tab -->
            <div class="modal-tab-panel" id="nicknamePanel">
                <div class="form-group">
                    <label class="form-label" for="nicknameInput">닉네임</label>
                    <input type="text" class="form-input" id="nicknameInput" placeholder="닉네임을 입력하세요" maxlength="20"
                           value="${profile.nickname}">
                    <div class="char-count">
                        <span id="charCount">9</span> / 20
                    </div>
                    <p class="form-hint">한글, 영문, 숫자만 사용 가능합니다. (2-20자)</p>
                </div>
            </div>
        </div>

        <div class="modal-actions">
            <button class="modal-btn modal-btn-cancel" id="modalCancel">취소</button>
            <button class="modal-btn modal-btn-save" id="modalSave">저장</button>
        </div>
    </div>
</div>

<footer class="footer">
    <div class="container">
        <div class="footer-content">
            <div class="footer-info">
                <h3>우리동네 심부름</h3>
                <p>이웃과 함께하는 따뜻한 심부름 커뮤니티</p>
            </div>
            <!-- ... Footer content same as main ... -->
        </div>
    </div>
</footer>

<script>
    // 서버에서 전달받은 심부름 데이터
    const myActivities = [
        <c:forEach var="errand" items="${errands}" varStatus="status">
        {
            errandsId: ${errand.errandsId},
            icon: '📦',
            badge: '심부름',
            title: '${errand.title}',
            description: '${errand.description}',
            price: '<fmt:formatNumber value="${errand.rewardAmount}" pattern="#,###"/>원',
            status: '${errand.status}',
            location: '${errand.gunguName} ${errand.dongName}',
            createdAt: '${errand.createdAt}'
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    // timrAgo 함수를 추가
    function timeAgo(dateString) {
        if (!dateString) return "";
        const now = new Date();
        const past = new Date(dateString);

        const diff = now - past;

        const seconds = Math.floor(diff / 1000);
        const minutes = Math.floor(seconds / 60);
        const hours = Math.floor(minutes / 60);
        const days = Math.floor(hours / 24);

        if (seconds < 60) return "방금 전";
        if (minutes < 60) return minutes + "분 전";
        if (hours < 24) return hours + "시간 전";
        if (days < 7) return days + "일 전";

        return dateString.substring(0, 10);
    }

    // 변수 선언
    let currentPage = 1;
    const itemsPerPage = 9;
    let currentFilter = 'all';
    let currentReportTask = null;

    // Function to render activities with pagination
    function renderActivities(filterType, page = 1) {
        currentFilter = filterType;
        currentPage = page;
        const gridContainer = document.getElementById('activityGrid');
        gridContainer.innerHTML = ''; // Clear existing

        let filteredData;
        if (filterType === 'all') {
            filteredData = myActivities;
        } else if (filterType === 'waiting') {
            filteredData = myActivities.filter(task => task.status === 'WAITING');
        } else if (filterType === 'reserved') {
            filteredData = myActivities.filter(task =>
                task.status === 'MATCHED' || task.status === 'CONFIRMED1' || task.status === 'CONFIRMED2');
        } else if (filterType === 'completed') {
            // 완료 탭: COMPLETED와 HOLD 모두 포함
            filteredData = myActivities.filter(task => task.status === 'COMPLETED' || task.status === 'HOLD');
        } else {
            filteredData = myActivities.filter(task => task.status === filterType);
        }

        if (filteredData.length === 0) {
            gridContainer.innerHTML = '<div style="grid-column: 1/-1; text-align: center; padding: 3rem; color: var(--color-gray);">해당하는 내역이 없습니다.</div>';
            renderPagination(0, page);
            return;
        }

// --- 여기부터 붙여넣으세요 ---

        // 1. 페이지네이션 계산
        const totalPages = Math.ceil(filteredData.length / itemsPerPage);
        const startIndex = (page - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        const paginatedData = filteredData.slice(startIndex, endIndex);

        // 2. 리스트 그리기
        paginatedData.forEach((task, index) => {
            const taskCard = document.createElement('div');
            taskCard.className = 'task-card';

            // 상태 배지 로직
            let statusLabel = '';
            if (task.status === 'WAITING') {
                statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#6B8E23; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">부름중</span>';
            } else if (task.status === 'MATCHED' || task.status === 'CONFIRMED1' || task.status === 'CONFIRMED2') {
                statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#F2B807; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">예약중</span>';
            } else if (task.status === 'COMPLETED') {
                statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#7F8C8D; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">완료</span>';
            } else if (task.status === 'CANCELED') {
                statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#e74c3c; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">취소</span>';
            } else if (task.status === 'HOLD') {
                statusLabel = '<span style="position:absolute; top:10px; right:10px; background:#e74c3c; color:#fff; padding:2px 8px; border-radius:4px; font-size:0.7rem; z-index:2;">보류</span>';
            }

            // 신고하기 버튼 (보류 상태일 때만)
            const reportButton = task.status === 'HOLD'
                ? '<button class="report-btn" data-task-index="' + (startIndex + index) + '" style="margin-left:8px; padding:2px 8px; font-size:0.7rem; vertical-align:middle;">신고하기</button>'
                : '';

            // 주소 처리 (없으면 공백)
            const locationText = task.location || '';

            // ★ 시간 변환 함수 적용! (여기서 방금 만든 함수를 씁니다)
            const displayTime = timeAgo(task.createdAt);

            taskCard.innerHTML = '<div class="task-image">' + task.icon + statusLabel + '</div>' +
                '<div class="task-card-content">' +
                '<div class="task-card-header">' +
                '<span class="task-badge">' + task.badge + '</span>' +
                // 변환된 시간(displayTime)을 보여줍니다
                '<span class="task-time" style="display:flex; align-items:center;">' + displayTime + reportButton + '</span>' +
                '</div>' +
                '<h3 class="task-card-title">' + task.title + '</h3>' +
                '<div class="task-author-info">' +
                '<div class="author-avatar" style="font-size:0.7rem; width:20px; height:20px; margin-right:5px;">👤</div>' +
                '<span class="author-name">' + (task.description || '') + '</span>' +
                '</div>' +
                '<div class="task-meta">' +
                '<span class="task-location">' + locationText + '</span>' +
                '<span class="task-price">' + task.price + '</span>' +
                '</div>' +
                '</div>';
            gridContainer.appendChild(taskCard);
        });

        // 신고하기 버튼 이벤트 연결
        document.querySelectorAll('.report-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.stopPropagation();
                const taskIndex = parseInt(btn.dataset.taskIndex);
                currentReportTask = myActivities[taskIndex];
                openReportModal();
            });
        });

        // 페이지네이션 그리기
        renderPagination(totalPages, page);
    }

    // Function to render pagination
    function renderPagination(totalPages, currentPage) {
        const paginationContainer = document.getElementById('paginationContainer');
        paginationContainer.innerHTML = '';

        if (totalPages <= 1) {
            return; // Don't show pagination if only one page
        }

        // Previous button
        const prevBtn = document.createElement('button');
        prevBtn.className = 'pagination-btn';
        prevBtn.innerHTML = '&laquo;';
        prevBtn.disabled = currentPage === 1;
        prevBtn.addEventListener('click', () => {
            if (currentPage > 1) {
                renderActivities(currentFilter, currentPage - 1);
            }
        });
        paginationContainer.appendChild(prevBtn);

        // Page numbers
        const maxVisiblePages = 5;
        let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
        let endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

        if (endPage - startPage < maxVisiblePages - 1) {
            startPage = Math.max(1, endPage - maxVisiblePages + 1);
        }

        for (let i = startPage; i <= endPage; i++) {
            const pageBtn = document.createElement('button');
            pageBtn.className = 'pagination-btn';
            if (i === currentPage) {
                pageBtn.classList.add('active');
            }
            pageBtn.textContent = i;
            pageBtn.addEventListener('click', () => {
                renderActivities(currentFilter, i);
            });
            paginationContainer.appendChild(pageBtn);
        }

        // Next button
        const nextBtn = document.createElement('button');
        nextBtn.className = 'pagination-btn';
        nextBtn.innerHTML = '&raquo;';
        nextBtn.disabled = currentPage === totalPages;
        nextBtn.addEventListener('click', () => {
            if (currentPage < totalPages) {
                renderActivities(currentFilter, currentPage + 1);
            }
        });
        paginationContainer.appendChild(nextBtn);
    }

    // Initialize with all data
    renderActivities('all', 1);

    // Tab Click Listeners
    const tabs = document.querySelectorAll('.tab-btn');
    tabs.forEach(tab => {
        tab.addEventListener('click', function () {
            // Remove active class from all
            tabs.forEach(t => t.classList.remove('active'));
            // Add active class to clicked
            this.classList.add('active');

            // Determine filter type based on text content
            const tabText = this.textContent.trim();
            let filterType = 'all';
            if (tabText === '부름') filterType = 'waiting';
            else if (tabText === '예약') filterType = 'reserved';
            else if (tabText === '완료') filterType = 'completed';

            renderActivities(filterType, 1);
        });
    });

    // Report Modal Logic
    const reportModal = document.getElementById('reportModal');
    const reportModalClose = document.getElementById('reportModalClose');
    const reportCancel = document.getElementById('reportCancel');
    const reportSubmit = document.getElementById('reportSubmit');
    const reportReason = document.getElementById('reportReason');
    const reportCharCount = document.getElementById('reportCharCount');

    function openReportModal() {
        reportModal.classList.add('active');
        reportReason.value = '';
        reportCharCount.textContent = '0';
    }

    function closeReportModal() {
        reportModal.classList.remove('active');
        reportReason.value = '';
        currentReportTask = null;
    }

    reportModalClose.addEventListener('click', closeReportModal);
    reportCancel.addEventListener('click', closeReportModal);

    reportModal.addEventListener('click', (e) => {
        if (e.target === reportModal) {
            closeReportModal();
        }
    });

    // Character count for report
    reportReason.addEventListener('input', () => {
        const length = reportReason.value.length;
        reportCharCount.textContent = length;

        if (length > 500) {
            reportReason.value = reportReason.value.substring(0, 500);
            reportCharCount.textContent = '500';
        }
    });

    // Submit report
    reportSubmit.addEventListener('click', () => {
        const reason = reportReason.value.trim();

        if (!reason) {
            alert('신고 사유를 입력해주세요.');
            reportReason.focus();
            return;
        }

        if (reason.length < 10) {
            alert('신고 사유를 10자 이상 입력해주세요.');
            reportReason.focus();
            return;
        }

        // 백엔드 API 호출
        fetch('${pageContext.request.contextPath}/api/profile/report', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                errandId: currentReportTask.errandsId,
                title: '심부름꾼 신고 - ' + currentReportTask.title,
                content: reason,
                type: 'ERRANDER_REPORT'
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('신고가 접수되었습니다.\n관리자가 검토 후 조치하겠습니다.');
                closeReportModal();
            } else {
                alert('신고 접수에 실패했습니다: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 오류가 발생했습니다.');
        });
    });

    // Withdrawal Modal Logic
    const withdrawalModal = document.getElementById('withdrawalModal');
    const withdrawalBtn = document.getElementById('withdrawalBtn');
    const withdrawalModalClose = document.getElementById('withdrawalModalClose');
    const withdrawalCancel = document.getElementById('withdrawalCancel');
    const withdrawalConfirm = document.getElementById('withdrawalConfirm');
    const withdrawalPassword = document.getElementById('withdrawalPassword');

    // Open withdrawal modal
    withdrawalBtn.addEventListener('click', () => {
        withdrawalModal.classList.add('active');
        withdrawalPassword.value = ''; // Clear password field
    });

    // Close withdrawal modal
    function closeWithdrawalModal() {
        withdrawalModal.classList.remove('active');
        withdrawalPassword.value = '';
    }

    withdrawalModalClose.addEventListener('click', closeWithdrawalModal);
    withdrawalCancel.addEventListener('click', closeWithdrawalModal);

    // Close when clicking outside
    withdrawalModal.addEventListener('click', (e) => {
        if (e.target === withdrawalModal) {
            closeWithdrawalModal();
        }
    });

    // Confirm withdrawal
    withdrawalConfirm.addEventListener('click', () => {
        const password = withdrawalPassword.value;

        if (!password) {
            alert('비밀번호를 입력해주세요.');
            withdrawalPassword.focus();
            return;
        }

        if (!confirm('정말로 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
            return;
        }

        // 백엔드 API 호출
        fetch('${pageContext.request.contextPath}/api/profile/withdraw', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                password: password
            })
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('회원 탈퇴가 완료되었습니다. 그동안 VROOM을 이용해주셔서 감사합니다.');
                closeWithdrawalModal();
                window.location.href = '${pageContext.request.contextPath}/';
            } else {
                alert('탈퇴 실패: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 오류가 발생했습니다.');
        });
    });

    // Profile Edit Modal Logic
    const profileModal = document.getElementById('profileModal');
    const profileImage = document.getElementById('profileImage');
    const profileNickname = document.getElementById('profileNickname');
    const modalClose = document.getElementById('modalClose');
    const modalCancel = document.getElementById('modalCancel');
    const modalSave = document.getElementById('modalSave');
    const imageUpload = document.getElementById('imageUpload');
    const previewImage = document.getElementById('previewImage');
    const removeImage = document.getElementById('removeImage');
    const nicknameInput = document.getElementById('nicknameInput');
    const charCount = document.getElementById('charCount');

    // Tab switching
    const modalTabs = document.querySelectorAll('.modal-tab');
    const modalTabPanels = document.querySelectorAll('.modal-tab-panel');

    let currentImage = null;
    let currentNickname = 'VROOM 유저';

    // Open modal on profile image or nickname click
    profileImage.addEventListener('click', () => {
        profileModal.classList.add('active');
        // Switch to image tab
        switchTab('image');
    });

    profileNickname.addEventListener('click', () => {
        profileModal.classList.add('active');
        // Switch to nickname tab
        switchTab('nickname');
    });

    // Close modal
    function closeModal() {
        profileModal.classList.remove('active');
    }

    modalClose.addEventListener('click', closeModal);
    modalCancel.addEventListener('click', closeModal);

    // Close modal when clicking outside
    profileModal.addEventListener('click', (e) => {
        if (e.target === profileModal) {
            closeModal();
        }
    });

    // Tab switching logic
    function switchTab(tabName) {
        modalTabs.forEach(tab => {
            tab.classList.remove('active');
            if (tab.dataset.tab === tabName) {
                tab.classList.add('active');
            }
        });

        modalTabPanels.forEach(panel => {
            panel.classList.remove('active');
            if (panel.id === tabName + 'Panel') {
                panel.classList.add('active');
            }
        });
    }

    modalTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            switchTab(tab.dataset.tab);
        });
    });

    // Image upload
    imageUpload.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) {
            // Validate file type
            if (!file.type.match('image.*')) {
                alert('이미지 파일만 업로드 가능합니다.');
                return;
            }

            // Validate file size (5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('파일 크기는 5MB를 초과할 수 없습니다.');
                return;
            }

            const reader = new FileReader();
            reader.onload = (event) => {
                currentImage = event.target.result;
                previewImage.innerHTML = '<img src="' + currentImage + '" alt="Profile" style="width: 100%; height: 100%; object-fit: cover;">';
            };
            reader.readAsDataURL(file);
        }
    });

    // Remove image (reset to default)
    removeImage.addEventListener('click', () => {
        currentImage = null;
        previewImage.innerHTML = 'V';
        imageUpload.value = '';
    });

    // Nickname character count
    nicknameInput.addEventListener('input', () => {
        const length = nicknameInput.value.length;
        charCount.textContent = length;
    });

    // Save changes
    modalSave.addEventListener('click', () => {
        const activeTab = document.querySelector('.modal-tab.active').dataset.tab;

        if (activeTab === 'image') {
            // 이미지 업로드
            const file = imageUpload.files[0];
            if (file) {
                const formData = new FormData();
                formData.append('file', file);

                fetch('${pageContext.request.contextPath}/api/profile/image', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        profileImage.innerHTML = '<img src="${pageContext.request.contextPath}' + data.imagePath + '" alt="Profile" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">';
                        alert('프로필 이미지가 변경되었습니다.');
                        closeModal();
                    } else {
                        alert('이미지 업로드 실패: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버 오류가 발생했습니다.');
                });
            } else if (currentImage === null) {
                // 기본 이미지로 변경
                profileImage.innerHTML = 'V';
                closeModal();
            } else {
                closeModal();
            }
        } else if (activeTab === 'nickname') {
            const newNickname = nicknameInput.value.trim();

            if (newNickname.length < 2) {
                alert('닉네임은 최소 2자 이상이어야 합니다.');
                return;
            }

            const validPattern = /^[가-힣a-zA-Z0-9\s]+$/;
            if (!validPattern.test(newNickname)) {
                alert('한글, 영문, 숫자만 사용 가능합니다.');
                return;
            }

            // Ajax 호출
            fetch('${pageContext.request.contextPath}/api/profile/nickname', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ nickname: newNickname })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    profileNickname.textContent = newNickname;
                    closeModal();
                } else {
                    alert('닉네임 변경에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('서버 오류가 발생했습니다.');
            });
        }
    });

    // Dropdown Logic (Reused)
    document.addEventListener('DOMContentLoaded', function () {
        const dropdownBtn = document.getElementById('userDropdownBtn');
        const dropdownMenu = document.getElementById('userDropdownMenu');

        if (dropdownBtn && dropdownMenu) {
            dropdownBtn.addEventListener('click', function (e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('active');
            });

            document.addEventListener('click', function (e) {
                if (!dropdownMenu.contains(e.target) && !dropdownBtn.contains(e.target)) {
                    dropdownMenu.classList.remove('active');
                }
            });
        }
    });
</script>
</body>

</html>